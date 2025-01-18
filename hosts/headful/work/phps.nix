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
in {
  nix.settings = {
    substituters = ["https://fossar.cachix.org/"];
    trusted-public-keys = ["fossar.cachix.org-1:Zv6FuqIboeHPWQS7ysLCJ7UT7xExb4OE8c4LyGb5AsE="];
  };

  systemd.tmpfiles.settings.php =
    builtins.mapAttrs (name: drv: {
      "/var/lib/phps/${name}"."L+".argument = drv.outPath;
    })
    phps;
}
