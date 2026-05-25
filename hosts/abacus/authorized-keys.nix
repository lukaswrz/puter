{ pubkeys, ... }:
{
  users.users.root.openssh.authorizedKeys.keys = [
    pubkeys.hosts.vessel
  ];
}
