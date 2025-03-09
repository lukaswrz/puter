with import ../pubkeys.nix; {
  "user-lukas.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues (builtins.removeAttrs hosts ["insomniac"]));
  "user-insomniac.age".publicKeys = (builtins.attrValues users) ++ [hosts.insomniac];

  "microbin.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];

  "miniflux.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];

  "vaultwarden.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];

  "forgejo-mailer.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "forgejo-admin.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];

  "restic-vessel.age".publicKeys = (builtins.attrValues users) ++ [hosts.vessel];
  "restic-abacus.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
}
