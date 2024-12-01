{
  lib,
  pkgs,
  ...
}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  environment.systemPackages = with pkgs.kdePackages; [sddm-kcm discover kate];

  programs = {
    kdeconnect.enable = true;
    partition-manager.enable = true;
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
