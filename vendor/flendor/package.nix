{
  writeShellApplication,
  jq,
  rsync,
}:
writeShellApplication {
  name = "flendor";

  runtimeInputs = [
    jq
    rsync
  ];

  text = builtins.readFile ./flendor;
}
