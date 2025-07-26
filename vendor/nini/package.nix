{
  writeShellApplication,
  nixos-rebuild,
  openssh,
}:
writeShellApplication {
  name = "nini";

  runtimeInputs = [
    nixos-rebuild
    openssh
  ];

  text = builtins.readFile ./nini;
}
