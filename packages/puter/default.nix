{
  writeShellApplication,
  nixos-rebuild,
}:
writeShellApplication {
  name = "puter";
  runtimeInputs = [
    nixos-rebuild
  ];
  text = builtins.readFile ./puter.bash;
}
