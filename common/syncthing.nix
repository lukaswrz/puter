{
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:4000";
    overrideDevices = false;
    overrideFolders = false;
  };
}
