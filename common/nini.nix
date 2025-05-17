{inputs, ...}: {
  imports = [
    inputs.nini.nixosModules.default
  ];

  programs.nini = {
    enable = true;
    flakeref = "git+https://forgejo.helveticanonstandard.net/helvetica/puter.git";
  };
}
