{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    ./features/bottom.nix
    ./features/cava.nix
    ./features/direnv.nix
    ./features/fish.nix
    ./features/git.nix
    ./features/helix.nix
    ./features/joshuto.nix
    ./features/mmtc.nix
    ./features/mpd.nix
    ./features/mpris-proxy.nix
    ./features/mpv.nix
    ./features/qutebrowser
    ./features/readline.nix
    ./features/ssh.nix
  ];

  home.packages = with pkgs; [
    appimage-run
    wineWowPackages.unstableFull

    bat
    curl
    ffmpeg
    file
    gitui
    hexyl
    hyperfine
    imagemagick
    ncdu
    netcat-openbsd
    nmap
    procs
    progress
    pv
    rage
    rsync
    sops
    systeroid
    tokei
    vscodium
  ];

  xdg = {
    enable = true;
    mime.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  xdg.dataFile."flatpak/overrides/global".text = ''
    [Context]
    filesystems=/nix/store:ro;${config.xdg.dataHome}/fonts:ro;${config.xdg.dataHome}/icons:ro
  '';
}
