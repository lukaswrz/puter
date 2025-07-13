{
  inputs,
  config,
  ...
}:
let
  inherit (config.users) mainUser;
in
{
  age.secrets."user-${mainUser}".file = inputs.self + /secrets/users/${mainUser}.age;

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
        extraGroups = [ "wheel" ]; # TODO remove
      };
    };
  };
}
