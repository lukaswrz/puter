{pkgs, ...}: {
  services.xserver = {
    enable = true;
    desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
        settings.Theme.CursorTheme = "breeze_cursors";
      };
    };
    excludePackages = [pkgs.xterm];
  };

  environment = {
    systemPackages = [
      pkgs.discover
      pkgs.kate
      pkgs.sddm-kcm
    ];
    sessionVariables = {
      SUDO_ASKPASS = pkgs.writeShellScript "kdialogaskpass" ''
        exec ${pkgs.kdialog} --password Askpass
      '';
      MOZ_USE_XINPUT2 = "1";
      GDK_SCALE = "1";
    };
  };

  xdg.portal.xdgOpenUsePortal = true;

  programs = {
    kdeconnect.enable = true;
    partition-manager.enable = true;
  };
}
