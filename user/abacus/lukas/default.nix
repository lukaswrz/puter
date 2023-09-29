{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      gitea
    ];
    stateVersion = "23.11";
  };
}
