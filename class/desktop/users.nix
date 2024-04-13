{config, ...}: {
  age.secrets.user-guest.file = ../../secrets/user-guest.age;

  users = {
    groups.guest = {};

    users.guest = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-guest.path;
      extraGroups = ["wheel" "networkmanager" "gamemode"];
    };
  };

  services.displayManager.hiddenUsers = ["guest"];
}
