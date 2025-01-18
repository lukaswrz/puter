{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.jetbrains.phpstorm
  ];
}
