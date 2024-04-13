with import ../pubkeys.nix; {
  "user-lukas.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues hosts);
  "user-guest.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues desktops);
  "mail-lukas.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "vaultwarden.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "nextcloud-lukas.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "restic-vessel.age".publicKeys = (builtins.attrValues users) ++ [hosts.vessel];
}
