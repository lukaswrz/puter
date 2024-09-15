lib: _: {
  findModules = dirs:
    builtins.concatMap (dir:
      lib.pipe dir [
        (lib.fileset.fileFilter (
          file: file.hasExt "nix" && file.name != "default.nix"
        ))
        lib.fileset.toList
      ])
    dirs;

  formatHostPort = {
    host,
    port,
  }: "${host}:${builtins.toString port}";
}
