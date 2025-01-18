{
  config,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;

  users.groups.docker.members = config.users.normalUsers;

  environment.systemPackages = [
    pkgs.docker-compose
  ];
}
