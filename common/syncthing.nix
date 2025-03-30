{
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = "localhost:4000";
    overrideDevices = false;
    overrideFolders = false;
  };
}
