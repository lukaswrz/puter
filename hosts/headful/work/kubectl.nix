{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.kubectl
    pkgs.awscli
  ];
}
