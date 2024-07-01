{config, ...}: {
  age.secrets.user-lukas.file = ../secrets/user-lukas.age;

  users = {
    groups.lukas.gid = 1000;

    users = {
      root.hashedPassword = "!";
      lukas = {
        uid = 1000;
        isNormalUser = true;
        hashedPasswordFile = config.age.secrets.user-lukas.path;
        openssh.authorizedKeys.keys = builtins.attrValues (import ../pubkeys.nix).users;
        extraGroups = ["wheel" "networkmanager" "gamemode"];
        linger = true;
      };
    };
  };
}
