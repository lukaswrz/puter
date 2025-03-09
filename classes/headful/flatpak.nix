{inputs, ...}: {
  imports = [
    inputs.flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak.enable = true;
}
