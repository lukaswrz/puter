{ pkgs, ... }: {
  imports = [
    ../headless

    ./alacritty.nix
    ./firefox.nix
    ./i3status-rust.nix
    ./mako.nix
    ./mpv.nix
    ./sway.nix
    ./swayidle.nix
    ./swaylock.nix
    ./thunderbird.nix
    ./mpd.nix
    ./mpris-proxy.nix
    ./ncmpcpp.nix
    ./newsboat.nix
    ./syncthing.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [ gnome.adwaita-icon-theme ];
}
