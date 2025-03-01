{config, ...}: {
  users.users.root.openssh.authorizedKeys.keys = [
    config.pubkeys.hosts.vessel
  ];
}
