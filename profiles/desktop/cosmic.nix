{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {

    nix.settings = {
      substituters = [ "https://cosmic.cachix.org" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
    };

    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  };
}
