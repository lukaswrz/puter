with import ../pubkeys.nix; {
  "user-lukas.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues hosts);

  "microbin.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "vaultwarden.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];

  "restic-vessel.age".publicKeys = (builtins.attrValues users) ++ [hosts.vessel];
  "restic-abacus.age".publicKeys = (builtins.attrValues users) ++ [hosts.vessel];
}
