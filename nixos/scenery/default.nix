{
  imports = [
    ../global

    ../features/headful

    ./configuration.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.11";
}
