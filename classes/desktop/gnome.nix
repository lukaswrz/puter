{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  xdg.portal.xdgOpenUsePortal = true;
}
