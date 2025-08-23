{ inputs, ... }:
{
  imports = [
    inputs.nini.nixosModules.default
  ];

  programs.nini = {
    enable = true;
    flake = "git+https://forgejo.helveticanonstandard.net/helvetica/puter.git";
  };
}
