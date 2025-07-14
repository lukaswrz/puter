{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.trusted;
  inherit (config.networking) hostName;
in
{
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      systemService = true;
      openDefaultPorts = true;
      guiAddress = "${hostName}.tailnet.helveticanonstandard.net:4000";
      overrideDevices = false;
      overrideFolders = false;
    };
  };
}
