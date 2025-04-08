let
  pubkeys = import ../pubkeys.nix;
  inherit (pubkeys) users hosts;
in {
  "user-helvetica.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues (builtins.removeAttrs hosts ["insomniac"]));
  "user-insomniac.age".publicKeys = (builtins.attrValues users) ++ [hosts.insomniac];

  "miniflux.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];

  "vaultwarden.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];

  "forgejo-mailer.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "forgejo-admin.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];

  "restic-vessel.age".publicKeys = (builtins.attrValues users) ++ [hosts.vessel];
  "restic-abacus.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];

  "syncserver.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
}
