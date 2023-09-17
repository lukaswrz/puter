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
    ./features/cursor.nix
    ./features/darkman.nix
    ./features/direnv.nix
    ./features/fish.nix
    ./features/fnott.nix
    ./features/foot.nix
    ./features/fuzzel.nix
    ./features/gammastep.nix
    ./features/git.nix
    ./features/helix.nix
    ./features/i3status-rust.nix
    ./features/imv.nix
    ./features/joshuto.nix
    ./features/mmtc.nix
    ./features/mpd.nix
    ./features/mpris-proxy.nix
    ./features/mpv.nix
    ./features/qutebrowser
    ./features/readline.nix
    ./features/ssh.nix
    ./features/swayidle.nix
    ./features/swaylock.nix
    ./features/sway.nix
    ./features/zathura.nix
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
    ripdrag
    rsync
    sops
    systeroid
    tokei
    tutanota-desktop
    vscodium
    wf-recorder
  ];

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = let
        mkDefaultApplication = mimeTypes: desktopFile: (lib.genAttrs mimeTypes (_: desktopFile));
      in
        lib.attrsets.mergeAttrsList [
          (
            mkDefaultApplication [
              "x-scheme-handler/http"
              "x-scheme-handler/https"
              "text/html"
            ] "qutebrowser.desktop"
          )
          (
            mkDefaultApplication [
              "x-scheme-handler/mailto"
            ] "tutanota-desktop.desktop"
          )
          # TODO
          # (
          #   mkDefaultApplication [
          #     "inode/directory"
          #   ] ""
          # )
          # (
          #   mkDefaultApplication [
          #     "x-scheme-handler/geo"
          #   ] ""
          # )
          (
            mkDefaultApplication [
              "image/png"
              "image/jpeg"
              "image/webp"
              "image/avif"
              "image/heif"
              "image/bmp"
              "image/x-icns"
            ] "imv.desktop"
          )
          (
            mkDefaultApplication [
              "audio/aac"
              "audio/mp4"
              "audio/mpeg"
              "audio/mpegurl"
              "audio/ogg"
              "audio/vnd.rn-realaudio"
              "audio/vorbis"
              "audio/x-flac"
              "audio/x-mp3"
              "audio/x-mpegurl"
              "audio/x-ms-wma"
              "audio/x-musepack"
              "audio/x-oggflac"
              "audio/x-pn-realaudio"
              "audio/x-scpls"
              "audio/x-speex"
              "audio/x-vorbis"
              "audio/x-vorbis+ogg"
              "audio/x-wav"
            ] "mpv.desktop"
          )
          (
            mkDefaultApplication [
              "application/pdf"
            ] "zathura.desktop"
          )
          (
            mkDefaultApplication [
              # TODO: Add more text filetypes
              "text/plain"
              "text/x-cmake"
              "text/markdown"
              "application/x-docbook+xml"
              "application/json"
              "application/x-yaml"
            ] "helix.desktop"
          )
          (
            mkDefaultApplication [
              "video/3gp"
              "video/3gpp2"
              "video/divx"
              "video/fli"
              "video/mp2t"
              "video/mp4v-es"
              "video/msvideo"
              "video/quicktime"
              "video/vnd.mpegurl"
              "video/x-avi"
              "video/x-m4v"
              "video/x-mpeg2"
              "video/x-msvideo"
              "video/x-ms-wmx"
              "video/x-ogm+ogg"
              "video/x-theora+ogg"
              "video/3gpp"
              "video/avi"
              "video/dv"
              "video/flv"
              "video/mp4"
              "video/mpeg"
              "video/ogg"
              "video/vnd.divx"
              "video/vnd.rn-realvideo"
              "video/x-flv"
              "video/x-matroska"
              "video/x-ms-asf"
              "video/x-ms-wmv"
              "video/x-ogm"
              "video/x-theora"
              "application/x-matroska"
            ] "mpv.desktop"
          )
        ];
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desk";
      documents = "${config.home.homeDirectory}/doc";
      download = "${config.home.homeDirectory}/dl";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pic";
      publicShare = "${config.home.homeDirectory}/pub";
      templates = "${config.home.homeDirectory}/tpl";
      videos = "${config.home.homeDirectory}/vid";
    };
  };

  xdg.dataFile."flatpak/overrides/global".text = ''
    [Context]
    filesystems=/nix/store:ro;${config.xdg.dataHome}/fonts:ro;${config.xdg.dataHome}/icons:ro
  '';
}
