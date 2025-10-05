let
  pubkeys = import ../pubkeys.nix;
  inherit (pubkeys) users hosts;
in
{
  "users/helvetica.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues hosts);
  "users/insomniac.age".publicKeys = (builtins.attrValues users) ++ [ hosts.kaleidoscope ];

  "vaultwarden.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "miniflux.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "forgejo/mailer.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];
  "forgejo/admin.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "restic/vessel.age".publicKeys = (builtins.attrValues users) ++ [ hosts.vessel ];
  "restic/abacus.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "secure-boot/orchard.tar.age".publicKeys = (builtins.attrValues users) ++ [ hosts.orchard ];
  "secure-boot/abacus.tar.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];
  "secure-boot/vessel.tar.age".publicKeys = (builtins.attrValues users) ++ [ hosts.vessel ];
  "secure-boot/kaleidoscope.tar.age".publicKeys = (builtins.attrValues users) ++ [
    hosts.kaleidoscope
  ];
}
