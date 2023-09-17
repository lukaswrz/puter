{pkgs, ...}: {
  home = {
    username = "lukas";
    packages = with pkgs; [
      nvtop-amd
      mullvad-vpn
    ];
    stateVersion = "23.11";
  };
}
