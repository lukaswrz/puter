{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  virtualHostName = "bin.${domain}";
in {
  age.secrets = lib.mkSecrets {microbin = {};};

  services.microbin = {
    enable = true;
    passwordFile = config.age.secrets.microbin.path;
    settings = {
      MICROBIN_BIND = "127.0.0.1";
      MICROBIN_PORT = 8020;

      MICROBIN_PUBLIC_PATH = "https://${virtualHostName}/";

      MICROBIN_READONLY = true;

      MICROBIN_EDITABLE = true;
      MICROBIN_ETERNAL_PASTA = true;
      MICROBIN_HIGHLIGHTSYNTAX = true;
      MICROBIN_PRIVATE = true;
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_QR = true;
      MICROBIN_NO_FILE_UPLOAD = false;
      MICROBIN_ENCRYPTION_CLIENT_SIDE = true;

      MICROBIN_MAX_FILE_SIZE_ENCRYPTED_MB = 1024;
      MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB = 4096;

      MICROBIN_DISABLE_UPDATE_CHECKING = true;
      MICROBIN_DISABLE_TELEMETRY = true;
      MICROBIN_LIST_SERVER = false;
    };
  };

  services.nginx.virtualHosts.${virtualHostName} = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://${lib.formatHostPort {
      host = config.services.microbin.settings.MICROBIN_BIND;
      port = config.services.microbin.settings.MICROBIN_PORT;
    }}";
  };
}
