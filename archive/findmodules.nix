lib: {
  findModules =
    {
      recursive ? true,
      filter ? _: _: true,
    }:
    paths:
    let
      fullFilter = name: type: (lib.hasSuffix ".nix" name || type == "directory") && filter name type;

      findShallow =
        path:
        lib.pipe path [
          builtins.readDir
          (lib.filterAttrs fullFilter)
          builtins.attrNames
          (builtins.map (name: path + /${name}))
        ];

      handlePath =
        path:
        if !lib.pathIsDirectory path then
          [ path ]
        else if recursive then
          builtins.concatMap handlePath (findShallow path)
        else
          findShallow path;
    in
    builtins.concatMap handlePath paths;
}
