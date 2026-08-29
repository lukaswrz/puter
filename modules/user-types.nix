{
  config,
  lib,
  ...
}:
let
  inherit (lib) types;
  filterUsers =
    predicate:
    (lib.pipe config.users.users [
      (lib.filterAttrs (_: predicate))
      builtins.attrNames
    ]);
in
{
  options.users = {
    normalUsers = lib.mkOption {
      type = types.listOf (types.passwdEntry types.str);
      description = ''
        List of normal users.
      '';
      readOnly = true;
    };

    systemUsers = lib.mkOption {
      type = types.listOf (types.passwdEntry types.str);
      description = ''
        List of system users.
      '';
      readOnly = true;
    };
  };

  config.users = {
    normalUsers = filterUsers (user: user.isNormalUser);
    systemUsers = filterUsers (user: user.isSystemUser);
  };
}
