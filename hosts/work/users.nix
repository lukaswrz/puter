{ config, inputs, ... }:
{
  age.secrets.user-lukas.file = inputs.self + /secrets/users/helvetica.age;

  users.users.lukas = {
    description = "Lukas Wurzinger";
    uid = 1000;
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.user-lukas.path;
    openssh.authorizedKeys.keys = builtins.attrValues config.pubkeys.users;
    extraGroups = [ "wheel" ]; # TODO remove
  };
}
