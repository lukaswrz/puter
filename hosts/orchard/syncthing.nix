{ config, ... }:
let
  tailnet = "tailnet.moontide.ink";
in
{
  services.syncthing-multi.instances.helvetica.settings.gui-address =
    "${config.networking.hostName}.${tailnet}:4010";
}
