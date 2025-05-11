{ config, lib, ... }:
let
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "desktop";
  };

  # imports = lib.optionals cfg.enable (lib.findModules {} [./profile]);

  config = lib.mkIf cfg.enable {
    imports = lib.findModules { } [ ./profile ];

    assertions = [
      {
        assertion = config.profiles.server.enable == false;
        message = "The desktop profile is not compatible with the server profile.";
      }
    ];
  };

  # config.assertions = lib.mkIf cfg.enable [
  #   {
  #     assertion = config.profiles.server.enable == false;
  #     message = "The desktop profile is not compatible with the server profile.";
  #   }
  # ];
}
