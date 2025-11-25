{
  config,
  inputs,
  ...
}:
{
  age.secrets.miniflux.file = inputs.self + /secrets/miniflux.age;

  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = config.age.secrets.miniflux.path;
    config = {
      LISTEN_ADDR = "${config.networking.hostName}.tailent.helveticanonstandard.net:6010";
      BASE_URL = "http://${config.networking.hostName}.tailent.helveticanonstandard.net";
      CREATE_ADMIN = 1;
      WEBAUTHN = 1;
    };
  };
}
