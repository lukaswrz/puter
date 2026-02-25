{
  lib,
  ...
}:
let
  parent = "/var/www";
  sites = [
    "moontide.ink"
    "wrz.one"
  ];
in
lib.mkMerge (
  map (
    site:
    let
      root = "${parent}/${site}";
    in
    {
      services.nginx.virtualHosts.${site} = {
        enableACME = true;
        forceSSL = true;

        inherit root;
      };

      systemd.tmpfiles.settings."10-sites".${root}.d = {
        user = "m64";
        group = "users";
        mode = "0755";
      };
    }
  ) sites
)
