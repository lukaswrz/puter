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

  selectedPhp = "php84";

  extraConfig = ''
    memory_limit = -1

    xdebug.mode = develop,coverage,gcstats,profile,debug,trace
    xdebug.discover_client_host = 1
    xdebug.client_host = localhost
  '';

  phps = lib.genAttrs supportedPhps (
    phpName:
      inputs.phps.packages.${pkgs.system}.${phpName}.buildEnv {
        extensions = {
          enabled,
          all,
        }:
          enabled ++ [all.xdebug all.amqp];
        inherit extraConfig;
      }
  );

  prefix = "/var/lib/phps";
  /*
  phpHomeLink = ".local/bin/php";

  usephp = pkgs.writeShellApplication {
    name = "usephp";
    text = ''
      if (( $# != 1 )); then
        echo incorrect number of arguments >&2
        exit 1
      fi
      ln --symbolic --force -- ${lib.escapeShellArg prefix}/"$1"/bin/php ~/${lib.escapeShellArg phpHomeLink}
    '';
  };

  composer = pkgs.writeShellApplication {
    name = "composer";
    text = ''
      php=~/${lib.escapeShellArg phpHomeLink}
      if [[ ! -x $php ]]; then
        echo php has not been linked >&2
        exit 1
      fi
      exec -- "$php" ${pkgs.phpPackages.composer}/bin/.composer-wrapped
    '';
  };
  */
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

  /*
  environment.systemPackages = [
    usephp
    composer
  ];
  */
}
