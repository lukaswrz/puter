{ pkgs, ... }:
{
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };

  environment = {
    systemPackages = [
      pkgs.librewolf
      pkgs.jellyfin-desktop
    ];
  };
}
