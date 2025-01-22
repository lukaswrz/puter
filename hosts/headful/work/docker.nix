{
  config,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;

  environment.systemPackages = [
    pkgs.docker-compose
  ];

  users.groups.docker.members = config.users.normalUsers;
}
