{ config, ... }:
{
  users.users.helvetica = {
    description = "Helvetica";
    uid = 1000;
    isNormalUser = true;
    password = "";
    openssh.authorizedKeys.keys = builtins.attrValues config.pubkeys.users;
    extraGroups = [ "wheel" ]; # TODO remove
  };
}
