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
    services.printing = {
      enable = true;
      webInterface = true;
    };
  };
}
