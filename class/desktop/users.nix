{
  users = {
    groups.guest = {};

    users.guest = {
      isNormalUser = true;
      password = "guest";
      extraGroups = ["wheel" "networkmanager" "gamemode"];
    };
  };
}
