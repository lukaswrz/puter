{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.headful;
in
{
  options.profiles.headful = {
    enable = lib.mkEnableOption "headful";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.profiles.server.enable;
        message = "The headful profile is not compatible with the server profile.";
      }
    ];

    environment = {
      systemPackages = [
        pkgs.wl-clipboard
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        SDL_VIDEODRIVER = "wayland,x11";
      };
    };

    fonts = {
      enableDefaultPackages = true;
      packages = [
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-cjk-serif
        pkgs.noto-fonts-monochrome-emoji
        pkgs.noto-fonts-color-emoji
        pkgs.nerd-fonts.fira-code
      ];

      fontconfig = {
        enable = true;

        defaultFonts = {
          monospace = [
            "FiraCode Nerd Font"
          ];
          sansSerif = [
            "Noto Sans"
          ];
          serif = [
            "Noto Serif"
          ];
          emoji = [
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };
      };
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
