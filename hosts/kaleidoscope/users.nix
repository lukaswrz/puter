{
  config,
  secretsPath,
  pubkeys,
  ...
}:
{
  age.secrets.user-insomniac.file = secretsPath + /users/insomniac.age;

  users.users.insomniac = {
    description = "Insomniac";
    uid = 1001;
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.user-insomniac.path;
    openssh.authorizedKeys.keys = builtins.attrValues pubkeys.users ++ [
      pubkeys.hosts.vessel
    ];
  };

  services.displayManager.hiddenUsers = [ "m64" ];
}
