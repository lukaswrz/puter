{
  writeShellApplication,
  util-linux,
  jq,
  e2fsprogs,
  dosfstools,
}:
writeShellApplication {
  name = "zap";

  runtimeInputs = [
    util-linux
    jq
    e2fsprogs
    dosfstools
  ];

  text = builtins.readFile ./zap;
}
