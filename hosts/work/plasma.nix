{
  lib,
  pkgs,
  ...
}:
{
  services = {
    desktopManager = {
      cosmic.enable = lib.mkForce false;
      plasma6.enable = true;
    };
    displayManager = {
      cosmic-greeter.enable = lib.mkForce false;
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs.kdePackages.sddm-kcm
    pkgs.kdePackages.discover
    pkgs.kdePackages.kate
  ];

  programs = {
    kdeconnect.enable = true;
    partition-manager.enable = true;
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
