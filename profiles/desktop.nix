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
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
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
      cosmic.excludePackages = [
        pkgs.cosmic-player
        pkgs.cosmic-reader
        pkgs.cosmic-wallpapers
      ];

      systemPackages = [
        pkgs.librewolf
        pkgs.supersonic-wayland
        pkgs.obs-studio
        pkgs.mpv
        pkgs.thunderbird
        pkgs.fluffychat
        pkgs.halloy
        pkgs.freetube
        pkgs.jellyfin-desktop
        pkgs.gimp
        pkgs.inkscape
        pkgs.libreoffice
        pkgs.libresprite
        pkgs.qbittorrent
        # pkgs.qutebrowser
        # pkgs.aerc
      ];
    };

    boot.kernel.sysctl = {
      # This is required due to some games being unable to reuse their TCP ports
      # if they're killed and restarted quickly - the default timeout is too
      # large.
      "net.ipv4.tcp_fin_timeout" = 5;
      # Use MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
      # See comment in include/linux/mm.h in the kernel tree.
      "vm.max_map_count" = 2147483642;
    };
  };
}
