{ config, ... }:
let
  inherit (config.networking) hostName;
in
{
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = "${hostName}.tailnet.helveticanonstandard.net:4000";
    overrideDevices = false;
    overrideFolders = false;
  };
}
