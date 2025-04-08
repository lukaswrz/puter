{lib, ...}: {
  services.syncthing.enable = lib.mkForce false;
}
