{ pkgs, ... }:
{
  environment.systemPackages =
    let
      retroarch = pkgs.retroarch.withCores (cores: [
        cores.parallel-n64
        cores.dolphin
      ]);
    in
    [
      retroarch
    ];
}
