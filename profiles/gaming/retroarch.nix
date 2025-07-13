{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.gaming;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      let
        retroarch = pkgs.retroarch.withCores (cores: [
          cores.parallel-n64
          cores.dolphin
        ]);
      in
      [ retroarch ];
  };
}
