{lib, ...}: {
  location.provider = "geoclue2";
  services.automatic-timezoned.enable = true;
  services.geoclue2.enableDemoAgent = lib.mkForce true;
}
