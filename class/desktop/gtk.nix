{pkgs, ...}: {
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];

  programs.dconf.enable = true;
}
