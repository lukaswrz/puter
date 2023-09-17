{pkgs, ...}: {
  home = {
    username = "lukas";
    packages = with pkgs; [
      gitea
    ];
    stateVersion = "23.11";
  };
}
