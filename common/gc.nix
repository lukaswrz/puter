{
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };

  boot.loader.systemd-boot.configurationLimit = 10;
}
