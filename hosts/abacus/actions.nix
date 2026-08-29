{
  secretsPath,
  config,
  ...
}:
{
  age.secrets.forgejo-runner.file = secretsPath + /forgejo/runner.age;

  services.forgejo-runner = {
    instances.default = {
      enable = true;
      settings = {
        runner.labels = [
          "debian:docker://debian:unstable"
        ];
        server.connections.default = {
          url = "https://hack.moontide.ink";
          uuid = "24fd3aed-60ed-4413-8aed-a4c452b28a3f";
        };
      };
      secrets.server.connections.default.token_url = config.age.secrets.forgejo-runner.path;
    };
  };
}
