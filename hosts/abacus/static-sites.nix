{
  lib,
  ...
}:
let
  parent = "/var/www";
  sites = [
    "wrz.one"
    "moontide.ink"
  ];
in
lib.mkMerge (
  map (
    virtualHostName:
    let
      root = "${parent}/${virtualHostName}";
    in
    {
      services.nginx.virtualHosts.${virtualHostName} = {
        enableACME = true;
        forceSSL = true;

        inherit root;
      };

      systemd.tmpfiles.settings."10-static-sites".${root}.d = {
        user = "m64";
        group = "users";
        mode = "0755";
      };
    }
  ) sites
)
