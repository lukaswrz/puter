{
  config,
  lib,
  ...
}: {
  options.users = let
    inherit (lib) types;
  in {
    normalUsers = lib.mkOption {
      type = types.listOf (types.passwdEntry types.str);
      description = ''
        List of normal users.
      '';
    };

    systemUsers = lib.mkOption {
      type = types.listOf (types.passwdEntry types.str);
      description = ''
        List of system users.
      '';
    };
  };

  config.users = let
    filterUsers = pred: (lib.pipe config.users.users [
      (lib.filterAttrs (_: pred))
      builtins.attrNames
    ]);
  in {
    normalUsers = filterUsers (user: user.isNormalUser);
    systemUsers = filterUsers (user: user.isSystemUser);
  };
}
