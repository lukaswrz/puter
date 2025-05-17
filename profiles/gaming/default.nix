{ config, lib, ... }:
let
  cfg = config.profiles.gaming;
in
{
  options.profiles.gaming = {
    enable = lib.mkEnableOption "gaming";
  };

  config.assertions = lib.mkIf cfg.enable [
    {
      assertion = config.profiles.desktop.enable;
      message = "The gaming profile depends on the desktop profile.";
    }
  ];
}
