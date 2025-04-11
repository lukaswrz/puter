{
  lib,
  fossarPhps,
  symlinkJoin,
  symfony-cli,
  makeWrapper,
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

  extraConfig = ''
    memory_limit = -1

    xdebug.mode = develop,coverage,gcstats,profile,debug,trace
    xdebug.discover_client_host = 1
    xdebug.client_host = localhost
  '';

  # Wrap all PHP versions with the extensions I need and bundle composer
  phps = lib.genAttrs supportedPhps (
    phpName: let
      phpBase = fossarPhps.${phpName};
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
      phpWithTools = symlinkJoin {
        inherit (phpWithEnv) name version meta passthru;
        paths = [
          phpWithEnv
          phpWithEnv.packages.composer
        ];
      };
    in
      phpWithTools
  );

  package = symfony-cli;
in
  # Tell Symfony's CLI where it can access the different PHP versions
  symlinkJoin {
    inherit (package) pname version meta;

    paths = [package];

    buildInputs = [makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/${package.meta.mainProgram} \
        --suffix PATH : ${lib.makeBinPath (
        builtins.attrValues phps
      )}
    '';
  }
