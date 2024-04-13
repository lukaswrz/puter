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

  environment = {
    systemPackages = with pkgs.kdePackages; [discover kate];
    sessionVariables = {
      SUDO_ASKPASS = pkgs.writeShellScript "kdialogaskpass" ''
        exec ${lib.getExe' pkgs.kdialog "kdialog"} --password Askpass
      '';
      MOZ_USE_XINPUT2 = "1";
      GDK_SCALE = "1";
    };
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  programs = {
    kdeconnect.enable = true;
    partition-manager.enable = true;
    dconf.enable = true;
  };
}
