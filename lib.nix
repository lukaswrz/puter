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

  mkIfElse =
    condition: trueContent: falseContent:
    lib.mkMerge [
      (lib.mkIf condition trueContent)
      (lib.mkIf (!condition) falseContent)
    ];

  mkSecrets =
    secrets:
    let
      mkSecret =
        {
          name,
          secret,
        }:
        secret
        // {
          file = ./secrets/${name}.age;
        };
    in
    builtins.mapAttrs (name: secret: mkSecret { inherit name secret; }) secrets;

  genNixosConfigurations =
    inputs:
    let
      modulesDir = ./modules;
      profilesDir = ./profiles;
      commonDir = ./common;
      hostsDir = ./hosts;

      commonNixosSystem =
        name:
        lib.nixosSystem {
          specialArgs = {
            inherit (inputs) self;
            inherit inputs lib;
            attrName = name;
          };

          modules =
            (lib.findModules [
              modulesDir
              profilesDir
              commonDir
              (hostsDir + /${name})
            ]);
        };

      hosts = lib.pipe hostsDir [
        builtins.readDir
        (lib.filterAttrs (_: type: type == "directory"))
        builtins.attrNames
      ];
    in
    lib.genAttrs hosts commonNixosSystem;
}
