{
  config,
  lib,
  ...
}: let
  inherit (config.users) mainUser;
in {
  users = {
    mainUser = lib.mkForce "user";
    users.${mainUser}.description = lib.mkForce "User";
  };
}
