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
    location.provider = "geoclue2";
  };
}
