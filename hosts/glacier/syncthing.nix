{ config, ... }:
let
  tailnet = "tailnet.moontide.ink";
in
{
  services.syncthing-multi.instances.m64.settings.gui-address =
    "${config.networking.hostName}.${tailnet}:4010";
}
