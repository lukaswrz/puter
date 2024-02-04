{pkgs, ...}: {
  # TODO
  # displayManager = {
  #   defaultSession = "plasmawayland";
  #   sddm = {
  #     enable = true;
  #     autoNumlock = true;
  #     settings = {
  #       Theme = {
  #         CursorTheme = "breeze_cursors";
  #       };
  #     };
  #   };
  # };

  services = {
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      displayManager.sddm.enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
    };
  };

  environment = {
    systemPackages = [
      pkgs.discover
      pkgs.sddm-kcm
    ];
    sessionVariables = {
      "SUDO_ASKPASS" = pkgs.writeShellScript "kdialogaskpass" ''
        exec ${pkgs.kdialog} --password Askpass
      '';
      "MOZ_USE_XINPUT2" = "1";
      "GDK_SCALE" = "1";
    };
  };

  xdg.portal.xdgOpenUsePortal = true;

  programs.kdeconnect.enable = true;
}
