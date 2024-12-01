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

    users = {
      root = {
        hashedPassword = "!";
        openssh.authorizedKeys.keys = builtins.attrValues (import ../pubkeys.nix).hosts;
      };
      ${mainUser} = {
        uid = 1000;
        isNormalUser = true;
        hashedPasswordFile = config.age.secrets."user-${mainUser}".path;
        openssh.authorizedKeys.keys = builtins.attrValues (import ../pubkeys.nix).users;
        extraGroups = ["wheel"];
      };
    };
  };
}
