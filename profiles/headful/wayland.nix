{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.headful;
in
{
  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SDL_VIDEODRIVER = "wayland,x11";
    };
  };
}
