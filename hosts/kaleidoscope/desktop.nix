{ pkgs, ... }:
{
  services = {
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "insomniac";
      };
    };
  };

  environment = {
    systemPackages = [
      pkgs.librewolf
      pkgs.jellyfin-desktop
      pkgs.dolphin-emu
    ];
  };
}
