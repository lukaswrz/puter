{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.gnumake
    pkgs.unzip
    pkgs.pv
    pkgs.jq
    pkgs.mariadb
    pkgs.openssl
  ];
}
