{
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    overrideDevices = false;
    overrideFolders = false;
  };
}
