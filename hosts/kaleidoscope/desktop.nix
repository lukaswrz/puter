{ pkgs, ... }:
{
  services = {
    desktopManager.cosmic.enable = true;
    displayManager = {
      cosmic-greeter.enable = true;
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
    ];
  };
}
