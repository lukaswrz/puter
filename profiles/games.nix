{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.games;
in
{
  options.profiles.games = {
    enable = lib.mkEnableOption "games";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.profiles.desktop.enable;
        message = "The games profile depends on the desktop profile.";
      }
    ];

    environment.systemPackages = [
      # Standalone
      pkgs.luanti
      pkgs.xonotic
      pkgs.mindustry-wayland
      pkgs.wesnoth

      # Needs content
      pkgs.uzdoom
      pkgs.vkquake
      pkgs.yquake2-all-games
      pkgs.ioquake3
      pkgs.openmw
      pkgs.taisei

      # Emulators and runtimes
      pkgs.ppsspp-qt
      pkgs.pcsx2
      pkgs.melonds
      pkgs.azahar
      pkgs.ruffle
      pkgs.dolphin-emu
      pkgs.flycast
      pkgs.duckstation
      pkgs.azahar

      # Decompilations
      pkgs.shipwright
      pkgs._2ship2harkinian
      pkgs.spaghettikart

      # Minecraft
      pkgs.prismlauncher
    ];
  };
}
