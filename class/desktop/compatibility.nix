{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.appimage-run
    pkgs.wineWowPackages.unstableFull
  ];

  services.envfs.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = [
      pkgs.alsa-lib
      pkgs.atk
      pkgs.at-spi2-atk
      pkgs.at-spi2-core
      pkgs.cairo
      pkgs.cups
      pkgs.curl
      pkgs.dbus
      pkgs.expat
      pkgs.fontconfig
      pkgs.freetype
      pkgs.fuse
      pkgs.fuse3
      pkgs.gdk-pixbuf
      pkgs.glib
      pkgs.gtk3
      pkgs.gtk4
      pkgs.icu
      pkgs.libappindicator
      pkgs.libdrm
      pkgs.libGL
      pkgs.libglvnd
      pkgs.libnotify
      pkgs.libpulseaudio
      pkgs.libunwind
      pkgs.libusb1
      pkgs.libuuid
      pkgs.libxkbcommon
      pkgs.libxml2
      pkgs.mesa
      pkgs.nspr
      pkgs.nss
      pkgs.openssl
      pkgs.pango
      pkgs.pipewire
      pkgs.stdenv.cc.cc
      pkgs.systemd
      pkgs.vulkan-loader
      pkgs.xorg.libX11
      pkgs.xorg.libxcb
      pkgs.xorg.libXcomposite
      pkgs.xorg.libXcursor
      pkgs.xorg.libXdamage
      pkgs.xorg.libXext
      pkgs.xorg.libXfixes
      pkgs.xorg.libXi
      pkgs.xorg.libxkbfile
      pkgs.xorg.libXrandr
      pkgs.xorg.libXrender
      pkgs.xorg.libXScrnSaver
      pkgs.xorg.libxshmfence
      pkgs.xorg.libXtst
      pkgs.zlib
    ];
  };
}
