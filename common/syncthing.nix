{
  config,
  inputs,
  ...
}:
let
  inherit (config.networking) hostName;
  tailnet = inputs.self.nixosConfigurations.abacus.config.services.headscale.settings.dns.base_domain;
in
{
  services.syncthing-multi = {
    enable = true;
    instances.syncthing.settings.gui-address = "${hostName}.${tailnet}:4000";
  };
}
