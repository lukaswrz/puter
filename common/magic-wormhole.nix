{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.magic-wormhole-rs ];
}
