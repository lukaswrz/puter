{lib, ...}: let
  inherit (lib) types;
in {
  options = {
    users.mainUser = lib.mkOption {
      type = types.passwdEntry types.str;
      default = "lukas";
      description = ''
        The main user.
      '';
    };
  };
}
