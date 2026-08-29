let
  pubkeys = import ../pubkeys.nix;
  inherit (pubkeys) users hosts;
in
{
  "users/lukas.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues hosts);
  "users/insomniac.age".publicKeys = (builtins.attrValues users) ++ [ hosts.kaleidoscope ];

  "vaultwarden.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "matrix/register.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "forgesync/github.age".publicKeys = (builtins.attrValues users) ++ [ hosts.vessel ];
  "forgesync/codeberg.age".publicKeys = (builtins.attrValues users) ++ [ hosts.vessel ];

  "forgejo/mailer.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];
  "forgejo/admin.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];
  "forgejo/runner.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "restic/vessel.age".publicKeys = (builtins.attrValues users) ++ [ hosts.vessel ];
  "restic/abacus.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "searx/searx.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];
  "searx/htpasswd.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "attic.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];
}
