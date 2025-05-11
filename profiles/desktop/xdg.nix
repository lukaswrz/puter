{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
  config = lib.mkIf cfg.enable {
    xdg.portal.xdgOpenUsePortal = true;
  };
}
