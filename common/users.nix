{
  config,
  lib,
  ...
}: let
  inherit (config.users) mainUser;
in {
  age.secrets = lib.mkSecrets {"user-${mainUser}" = {};};

  users = {
    mutableUsers = false;

    mainUser = "helvetica";

    users = {
      root.hashedPassword = "!";
      ${mainUser} = {
        description = "Helvetica";
        uid = 1000;
        isNormalUser = true;
        hashedPasswordFile = config.age.secrets."user-${mainUser}".path;
        openssh.authorizedKeys.keys = builtins.attrValues config.pubkeys.users;
        extraGroups = ["wheel"]; #TODO remove
      };
    };
  };
}
