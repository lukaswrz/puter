{
  config,
  lib,
  ...
}: let
  inherit (config.users) mainUser;
in {
  users = {
    mainUser = lib.mkForce "lukas";
    users.${mainUser}.description = lib.mkForce "Lukas Wurzinger";
  };
}
