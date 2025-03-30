{config, ...}: let
  inherit (config.networking) hostname;
in {
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = "${hostname}.tailnet.helveticanonstandard.net:4000";
    overrideDevices = false;
    overrideFolders = false;
  };
}
