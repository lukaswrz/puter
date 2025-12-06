{ config, inputs, ... }:
let
  tailnet = inputs.self.nixosConfigurations.abacus.config.services.headscale.settings.dns.base_domain;
in
{
  services.syncthing-multi.instances.helvetica.settings.gui-address =
    "${config.networking.hostName}.${tailnet}:4010";
}
