{
  config,
  secretsPath,
  ...
}:
{
  age.secrets.user-insomniac.file = secretsPath + /users/insomniac.age;

  users.users.insomniac = {
    description = "Insomniac";
    uid = 1001;
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.user-insomniac.path;
  };

  services.displayManager.hiddenUsers = [ "helvetica" ];
}
