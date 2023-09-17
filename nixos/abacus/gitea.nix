{config, ...}: let
  fqdn = "git.defenestrated.systems";
in {
  services.nginx.virtualHosts.${fqdn} = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      recommendedProxySettings = true;
      proxyPass = "http://127.0.0.1:${builtins.toString config.services.gitea.settings.server.HTTP_PORT}";
    };
  };

  services.gitea = {
    enable = true;

    appName = "git.defenestrated.systems";

    database.type = "postgres";

    settings = {
      server = {
        ROOT_URL = "https://${fqdn}/";
        HTTP_PORT = 8020;
        DOMAIN = fqdn;
        DISABLE_REGISTRATION = true;
      };
    };

    lfs.enable = true;
  };

  services.postgresql = {
    enable = true;

    authentication = ''
      local gitea all ident map=gitea-users
    '';

    identMap = ''
      gitea-users gitea gitea
    '';
  };
}
