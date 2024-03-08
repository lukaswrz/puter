{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-extra
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
      pkgs.noto-fonts-monochrome-emoji
      pkgs.noto-fonts-color-emoji
      (pkgs.nerdfonts.override {fonts = ["Noto"];})
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = ["NotoSansM Nerd Font"];
        sansSerif = ["Noto Sans"];
        serif = ["Noto Serif"];
        emoji = ["Noto Color Emoji" "Noto Emoji"];
      };
    };

    fontDir.enable = true;
  };
}
