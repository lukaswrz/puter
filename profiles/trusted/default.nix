{ lib, ... }:
{
  options.profiles.trusted = {
    enable = lib.mkEnableOption "trusted";
  };
}
