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
          pkgs.symfony-cli
        ];
      };
    in
      phpWithTools
  );

  prefix = "/var/lib/phps";
in {
  nix.settings = {
    substituters = ["https://fossar.cachix.org/"];
    trusted-public-keys = ["fossar.cachix.org-1:Zv6FuqIboeHPWQS7ysLCJ7UT7xExb4OE8c4LyGb5AsE="];
  };

  systemd.tmpfiles.settings =
    builtins.mapAttrs (name: drv: {
      "${prefix}/${name}"."L+".argument = drv.outPath;
    })
    phps;

  environment.systemPackages = [
    phps.${selectedPhp}.packages.composer
  ];
}
