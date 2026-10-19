{
  inputs,
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

    boot.kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];

    services = {
      greetd = {
        enable = true;
        settings.default_session.command = "${lib.getExe pkgs.tuigreet} --time --asterisks --cmd 'uwsm start river-uwsm.desktop'";
      };
      flatpak.enable = true;
      printing = {
        enable = true;
        webInterface = true;
      };
      ivpn.enable = true;
    };

    programs = {
      dconf.enable = true;
      uwsm = {
        enable = true;
        waylandCompositors.river = {
          prettyName = "River";
          comment = "River compositor managed by UWSM";
          binPath = lib.getExe pkgs.river;
        };
      };
    };

    xdg.portal = {
      enable = true;
      wlr = {
        enable = true;
        settings = {
          screencast = {
            # exec_before = "disable_notifications.sh";
            # exec_after = "enable_notifications.sh";
            chooser_type = "simple";
            chooser_cmd = "${lib.getExe pkgs.slurp} -f 'Monitor: %o' -or";
          };
        };
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];

      config = {
        common = {
          default = [ "gtk" ];
        };
        river = {
          "org.freedesktop.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.portal.Screenshot" = [ "wlr" ];
        };
      };
    };

    environment.systemPackages = [
      inputs.self.packages.${pkgs.system}.yadal
      pkgs.yt-dlp
      pkgs.gurk-rs
      pkgs.wiremix
      pkgs.aerc
      # pkgs.senpai

      inputs.self.packages.${pkgs.system}.gram
      pkgs.qutebrowser
      pkgs.mpv
      pkgs.pcmanfm-qt
      pkgs.lagrange
      pkgs.qpwgraph
      pkgs.halloy
      pkgs.fooyin
      pkgs.zathura

      inputs.self.packages.${pkgs.system}.beansprout
      pkgs.fuzzel
      pkgs.alacritty
      pkgs.phinger-cursors
      pkgs.playerctl
      pkgs.wlr-randr
      pkgs.kanshi
      pkgs.waylock
      pkgs.fnott
      pkgs.fyi
      pkgs.brightnessctl
      pkgs.gammastep
      pkgs.chayang
      pkgs.grim
      pkgs.slurp
      pkgs.poweralertd
      pkgs.wob
    ];

    security.pam.services.waylock = { };

    hardware.opentabletdriver.enable = true;
  };
}
