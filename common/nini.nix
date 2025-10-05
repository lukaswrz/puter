{ inputs, ... }:
{
  imports = [
    inputs.nini.nixosModules.default
  ];

  programs.nini = {
    enable = true;
    flake = "git+https://hack.helveticanonstandard.net/helvetica/puter.git";
  };
}
