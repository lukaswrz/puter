{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      displayManager = {
        defaultSession = "plasmawayland";
        sddm = {
          enable = true;
          autoNumlock = true;
          settings = {
            Theme = {
              CursorTheme = "breeze_cursors";
            };
          };
        };
      };
      excludePackages = with pkgs; [
        xterm
      ];
    };
  };

  programs.dconf.enable = true;

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  environment.sessionVariables = {
    "SUDO_ASKPASS" = pkgs.writeShellScript "kdialogaskpass" ''
      exec ${pkgs.kdialog} --password Askpass
    '';
    "MOZ_USE_XINPUT2" = "1";
    "GDK_SCALE" = "1";
  };

  environment.systemPackages = with pkgs; [
    discover
  ];
}
