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
    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;
      preferences = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "middlemouse.paste" = false;
        "general.autoScroll" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads" = false;
      };
    };
  };
}
