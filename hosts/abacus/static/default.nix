{
  imports = [
    ./log.nix
    ./main.nix
  ];

  systemd.tmpfiles.settings."10-static-sites"."/var/www".d = {
    user = "root";
    group = "root";
    mode = "0755";
  };
}
