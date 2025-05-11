{
  config,
  lib,
  ...
}:
let
  inherit (config.users) mainUser;
in
{
  users = {
    mainUser = lib.mkForce "insomniac";
    users.${mainUser}.description = lib.mkForce "Insomniac";
  };
}
