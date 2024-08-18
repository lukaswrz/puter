{
  #what?
  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
  };

  systemd.user.services.syncthing.wantedBy = ["default.target"];
}
