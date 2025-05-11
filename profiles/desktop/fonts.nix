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
  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = [
        pkgs.noto-fonts
        pkgs.noto-fonts-extra
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

      # TODO
      fontDir.enable = true;
    };
  };
}
