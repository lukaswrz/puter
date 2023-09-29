{
  pkgs,
  lib,
  ...
}: {
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      nvtop-amd
      mullvad-vpn
    ];
  };
}
