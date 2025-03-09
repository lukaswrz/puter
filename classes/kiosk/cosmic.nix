{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  nix.settings = {
    substituters = ["https://cosmic.cachix.org/"];
    trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
  };

  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;

    greetd.settings.initial_session = {
      user = config.users.mainUser;
      command = ''
        ${lib.getExe' pkgs.coreutils "env"} XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" systemd-cat --identifier start-cosmic ${lib.getExe' pkgs.cosmic-session "start-cosmic"}
      '';
    };
  };

  environment.cosmic.excludePackages = [
    pkgs.cosmic-store
  ];
}
