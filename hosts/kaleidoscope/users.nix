{
  config,
  secretsPath,
  pubkeys,
  ...
}:
{
  age.secrets = {
    user-m64.file = secretsPath + /users/m64.age;
    user-insomniac.file = secretsPath + /users/insomniac.age;
  };

  users.users = {
    m64 = {
      description = "m64";
      uid = 1000;
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-m64.path;
      openssh.authorizedKeys.keys = builtins.attrValues pubkeys.users;
      extraGroups = [ "wheel" ];
    };

    insomniac = {
      description = "Insomniac";
      uid = 1001;
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-insomniac.path;
      openssh.authorizedKeys.keys = builtins.attrValues pubkeys.users ++ [
        pubkeys.hosts.vessel
      ];
    };
  };

  services.displayManager.hiddenUsers = [ "m64" ];
}
