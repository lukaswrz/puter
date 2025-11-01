{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.trusted;
  inherit (config.networking) hostName;
  tailnet = config.services.headscale.settings.dns.base_domain;
in
{
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      systemService = true;
      openDefaultPorts = true;
      guiAddress = "${hostName}.${tailnet}:4000";
      overrideDevices = false;
      overrideFolders = false;
    };
  };
}
