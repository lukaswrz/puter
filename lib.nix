lib: _: {
  findModules = dirs:
    builtins.concatMap (dir:
      lib.pipe dir [
        (lib.fileset.fileFilter (
          file: file.hasExt "nix"
        ))
        lib.fileset.toList
      ])
    dirs;

  formatHostPort = {
    host,
    port,
  }: "${host}:${builtins.toString port}";

  mkSecrets = secrets: let
    mkSecret = {
      name,
      secret,
    }:
      secret
      // {
        file = ./secrets/${name}.age;
      };
  in
    builtins.mapAttrs (name: secret: mkSecret {inherit name secret;}) secrets;

  genNixosConfigurations = {
    inputs,
    extraModules ? _: [],
  }: let
    commonDir = ./common;
    classesDir = ./classes;
    hostsDir = ./hosts;

    commonNixosSystem = {
      class,
      name,
    }:
      lib.nixosSystem {
        specialArgs = {
          inherit (inputs) self;
          inherit inputs lib;
          attrName = name;
        };

        modules =
          (lib.findModules [
            commonDir
            ./classes/${class}
            (classesDir + /${class})
            (hostsDir + /${class}/${name})
          ])
          ++ [
            {networking.hostName = lib.mkDefault name;}
          ]
          ++ (extraModules {inherit class name;});
      };

    dirsIn = dir:
      lib.pipe (builtins.readDir dir) [
        (lib.filterAttrs (_: type: type == "directory"))
        builtins.attrNames
      ];
  in
    lib.pipe (dirsIn hostsDir) [
      (classes:
        builtins.concatMap (
          class: map (name: {inherit class name;}) (dirsIn (hostsDir + /${class}))
        )
        classes)
      (map (args: lib.nameValuePair args.name (commonNixosSystem args)))
      builtins.listToAttrs
    ];
}
