{ config, secretsPath, ... }:
let
  port = 1234;
  address = "vessel.tailnet.moontide.ink";
in
{
  age.secrets.searx.file = secretsPath + /searx.age;

  services.searx = {
    enable = true;
    redisCreateLocally = true;
    environmentFile = config.age.secrets.searx.path;
    settings.server = {
      bind_address = address;
      inherit port;
      base_url = "http://${address}:${toString port}/";
      secret_key = "$SEARX_SECRET_KEY";
    };
  };
}
