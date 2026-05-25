{ config, ... }:
let
  tailnet = "tailnet.moontide.ink";
in
{
  services.syncthing-multi.instances.insomniac.settings.gui-address =
    "${config.networking.hostName}.${tailnet}:4020";
}
