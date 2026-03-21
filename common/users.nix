{
  config,
  pubkeys,
  secretsPath,
  ...
}:
{
  age.secrets.user-helvetica.file = secretsPath + /users/helvetica.age;

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "!";

    users.helvetica = {
      description = "Lukas Wurzinger";
      uid = 1000;
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-helvetica.path;
      openssh.authorizedKeys.keys = builtins.attrValues pubkeys.users;
      extraGroups = [ "wheel" ]; # TODO remove
    };
  };
}
