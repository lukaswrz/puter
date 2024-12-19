{
  writeShellApplication,
  util-linux,
  jq,
  e2fsprogs,
  dosfstools,
}:
writeShellApplication {
  name = "disk";

  runtimeInputs = [
    util-linux
    jq
    e2fsprogs
    dosfstools
  ];

  text = builtins.readFile ./disk.bash;
}
