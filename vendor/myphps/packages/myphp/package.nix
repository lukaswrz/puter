{
  lib,
  php,
  symlinkJoin,
}: let
  extraConfig = ''
    memory_limit = -1

    xdebug.mode = develop,coverage,gcstats,profile,debug,trace
    xdebug.discover_client_host = 1
    xdebug.client_host = localhost
  '';

  # Build PHP environment with required extensions
  phpEnv = php.buildEnv {
    extensions = {
      enabled,
      all,
    }:
      enabled
      ++ [all.xdebug]
      ++ (
        if (lib.versionAtLeast php.version "8")
        then [all.amqp]
        else []
      );
    inherit extraConfig;
  };
in
  # Bundle composer alongside this PHP package
  symlinkJoin {
    inherit (phpEnv) name version meta passthru;
    paths = [
      phpEnv
      phpEnv.packages.composer
    ];
  }
