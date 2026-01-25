{
  config,
  inputs,
  pubkeys,
  ...
}:
{
  age.secrets = {
    user-helvetica.file = inputs.self + /secrets/users/helvetica.age;
    user-insomniac.file = inputs.self + /secrets/users/insomniac.age;
  };

  users.users = {
    helvetica = {
      description = "Helvetica";
      uid = 1000;
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.user-helvetica.path;
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

  services.displayManager.hiddenUsers = [ "helvetica" ];
}
