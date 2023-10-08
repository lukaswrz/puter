{lib, ...}: {
  location.provider = "geoclue2";
  services = {
    automatic-timezoned.enable = true;
    geoclue2.enableDemoAgent = lib.mkForce true;
  };
}
