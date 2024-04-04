{
  config,
  lib,
  ...
}: {
  # TODO
  age.secrets = {
    hiraeth-jwt-sign-key = {
      file = ../../secrets/hiraeth-jwt-sign-key.age;
      owner = "hiraeth";
      group = "hiraeth";
    };

    hiraeth-jwt-verify-key = {
      file = ../../secrets/hiraeth-jwt-verify-key.age;
      owner = "hiraeth";
      group = "hiraeth";
    };
  };

  services = {
    postgresql = {
      enable = lib.mkDefault true;

      ensureDatabases = ["hiraeth"];
      ensureUsers = [
        {
          name = "hiraeth";
          ensureDBOwnership = true;
        }
      ];
    };

    hiraeth = {
      enable = true;
      settings = {
        address = "127.0.0.1:8040";
        name = "hiraeth";
        db_type = "postgres";
        datadir = "/var/lib/hiraeth";
        dsn = "host=/run/postgresql user=hiraeth";
        jwt_sign_key_file = config.age.secrets.hiraeth-jwt-sign-key.path;
        jwt_verify_key_file = config.age.secrets.hiraeth-jwt-verify-key.path;
        chunk_size = 1024 * 1024 * 128;
        timeout = 60;
        inline_types = [
          "application/pdf"
          "audio/mpeg"
          "audio/flac"
          "audio/vorbis"
          "image/jpeg"
          "image/png"
          "text/plain"
          "video/mp4"
        ];
      };
    };

    nginx.virtualHosts."share.${config.networking.domain}" = {
      enableACME = true;
      forceSSL = true;
      quic = true;

      locations."/".proxyPass = "http://${config.services.hiraeth.settings.address}";
    };
  };
}
