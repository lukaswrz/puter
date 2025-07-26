{ config, inputs, ... }:
{
  age.secrets.user-helvetica.file = inputs.self + /secrets/users/helvetica.age;

  users.users.helvetica = {
    description = "Helvetica";
    uid = 1000;
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.user-helvetica.path;
    openssh.authorizedKeys.keys = builtins.attrValues config.pubkeys.users;
    extraGroups = [ "wheel" ]; # TODO remove
  };

  users.users.futura = {
    description = "Futura";
    uid = 1001;
    isNormalUser = true;
    password = "futura";
    openssh.authorizedKeys.keys = builtins.attrValues config.pubkeys.users;
    extraGroups = [ "wheel" ]; # TODO remove
  };
}
