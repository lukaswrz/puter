{pkgs, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  environment.systemPackages = [
    pkgs.gitui
  ];
}
