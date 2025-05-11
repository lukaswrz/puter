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
    programs.appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.curl
          pkgs.zlib
          pkgs.libmpg123
        ];
      };
    };

    boot.binfmt.emulatedSystems = lib.remove pkgs.stdenv.hostPlatform.system [
      "x86_64-linux"
      "aarch64-linux"
    ];

    environment.systemPackages = [
      pkgs.wineWow64Packages.waylandFull
    ];
  };
}
