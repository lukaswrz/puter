{pkgs, ...}: let
  puter = pkgs.writeShellApplication {
    name = "puter";
    runtimeInputs = [
      pkgs.nixos-rebuild
    ];
    text = builtins.readFile ./puter.bash;
  };
in {
  environment.systemPackages = [
    puter
  ];
}
