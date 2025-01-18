{pkgs, ...}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
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
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  programs.dconf.enable = true;
}
