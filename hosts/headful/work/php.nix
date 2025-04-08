{
  lib,
  inputs,
  pkgs,
  ...
}: let
  supportedPhps = [
    "php72"
    "php73"
    "php74"
    "php80"
    "php81"
    "php82"
    "php83"
    "php84"
  ];

  selectedPhp = lib.last supportedPhps;

  extraConfig = ''
    memory_limit = -1

    xdebug.mode = develop,coverage,gcstats,profile,debug,trace
    xdebug.discover_client_host = 1
    xdebug.client_host = localhost
  '';

  # Wrap all PHP versions with the extensions I need and bundle composer
  phps = lib.genAttrs supportedPhps (
    phpName: let
      phpBase = inputs.phps.packages.${pkgs.system}.${phpName};
      phpWithEnv = phpBase.buildEnv {
        extensions = {
          enabled,
          all,
        }:
          enabled
          ++ [all.xdebug]
          ++ (
            if (lib.versionAtLeast phpBase.version "8")
            then [all.amqp]
            else []
          );
        inherit extraConfig;
      };
      phpWithTools = pkgs.symlinkJoin {
        inherit (phpWithEnv) name version meta passthru;
        paths = [
          phpWithEnv
          phpWithEnv.packages.composer
        ];
      };
    in
      phpWithTools
  );

  prefix = "/var/lib/phps";

  # Tell Symfony's CLI where it can access the different PHP versions
  symfony-cli = let
    package = pkgs.symfony-cli;
  in
    pkgs.symlinkJoin {
      inherit (package) pname version meta;

      paths = [package];

      buildInputs = [pkgs.makeWrapper];

      postBuild = ''
        wrapProgram $out/bin/${package.meta.mainProgram} \
          --suffix PATH : ${pkgs.lib.makeBinPath (
          builtins.attrValues phps
        )}
      '';
    };
in {
  nix.settings = {
    substituters = ["https://fossar.cachix.org/"];
    trusted-public-keys = ["fossar.cachix.org-1:Zv6FuqIboeHPWQS7ysLCJ7UT7xExb4OE8c4LyGb5AsE="];
  };

  # Link PHP installations so that PhpStorm knows about them
  systemd.tmpfiles.settings =
    builtins.mapAttrs (name: drv: {
      "${prefix}/${name}"."L+".argument = drv.outPath;
    })
    phps;

  environment.systemPackages = [
    pkgs.jetbrains.phpstorm
    phps.${selectedPhp}
    symfony-cli
  ];
}
