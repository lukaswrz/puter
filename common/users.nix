{config, pubkeys, secretsPath, ...}: {
  age.secrets.user-m64.file = secretsPath + /users/m64.age;

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "!";

    users.m64 = {
      description = "Lukas Wurzinger";
      uid = 1000;
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-m64.path;
      openssh.authorizedKeys.keys = builtins.attrValues pubkeys.users;
      extraGroups = [ "wheel" ]; # TODO remove
    };
  };
}
