{
  config,
  pubkeys,
  secretsPath,
  ...
}:
{
  age.secrets.user-lukas.file = secretsPath + /users/lukas.age;

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "!";

    users.lukas = {
      description = "Lukas Wurzinger";
      uid = 1000;
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-lukas.path;
      openssh.authorizedKeys.keys = builtins.attrValues pubkeys.users;
    };
  };
}
