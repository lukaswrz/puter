{
  lib,
  pkgs,
  ...
}:
{
  services = {
    desktopManager = {
      cosmic.enable = lib.mkForce false;
      plasma6.enable = true;
    };
    displayManager = {
      cosmic-greeter.enable = lib.mkForce false;
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs.kdePackages.sddm-kcm
  ];
}
