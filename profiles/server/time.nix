{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.server;
in
{
  config = lib.mkIf cfg.enable {
    time.timeZone = "UTC";
  };
}
