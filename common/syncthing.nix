{
  config,
  ...
}:
let
  inherit (config.networking) hostName;
  tailnet = "tailnet.moontide.ink";
in
{
  services.syncthing-multi = {
    enable = true;
    instances.syncthing.settings.gui-address = "${hostName}.${tailnet}:4000";
  };
}
