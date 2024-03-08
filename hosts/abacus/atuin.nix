{
  config,
  lib,
  ...
}: {
  services = {
    postgresql = {
      enable = lib.mkDefault true;

      ensureDatabases = ["atuin"];
      ensureUsers = [
        {
          name = "atuin";
          ensureDBOwnership = true;
        }
      ];
    };

    atuin = {
      enable = true;
      openRegistration = false;
      database.uri = "postgresql:///atuin?host=/run/postgresql&user=atuin";
    };

    nginx.virtualHosts."atuin.${config.networking.domain}" = {
      enableACME = true;
      forceSSL = true;
      quic = true;

      locations."/".proxyPass = "http://${config.services.atuin.host}:${builtins.toString config.services.atuin.port}";
    };
  };
}
