{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.dynamic;
in
{
  config = lib.mkIf cfg.enable {
    location.provider = "geoclue2";
  };
}
