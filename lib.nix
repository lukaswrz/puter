lib: _: {
  findModules = paths:
    builtins.concatMap (path:
      lib.pipe path [
        (lib.fileset.fileFilter (
          file: file.hasExt "nix"
        ))
        lib.fileset.toList
      ])
    paths;

  mkIfElse = condition: trueContent: falseContent:
    lib.mkMerge [
      (lib.mkIf condition trueContent)
      (lib.mkIf (!condition) falseContent)
    ];

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
    modulesDir = ./modules;
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
            modulesDir
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
      lib.pipe dir [
        builtins.readDir
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
