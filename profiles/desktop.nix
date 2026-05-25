{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "desktop";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.profiles.server.enable;
        message = "The desktop profile is not compatible with the server profile.";
      }
      {
        assertion = config.profiles.headful.enable;
        message = "The desktop profile depends on the headful profile.";
      }
      {
        assertion = config.profiles.dynamic.enable;
        message = "The desktop profile depends on the dynamic profile.";
      }
    ];

    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      flatpak.enable = true;
      printing = {
        enable = true;
        webInterface = true;
      };
      mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
    };

    environment = {
      gnome.excludePackages = [
        pkgs.epiphany
      ];

      systemPackages = [
        # TODO: remove
        pkgs.librewolf
      ];
    };
  };
}
