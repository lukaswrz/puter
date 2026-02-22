{ pkgs, ... }:
{
  environment.systemPackages = [
    # Standalone
    pkgs.luanti
    pkgs.veloren
    pkgs.xonotic
    pkgs.mindustry-wayland
    pkgs.wesnoth
    pkgs.sauerbraten
    pkgs.shattered-pixel-dungeon

    # Needs content
    pkgs.uzdoom
    pkgs.vkquake
    pkgs.openmw
  ];
}
