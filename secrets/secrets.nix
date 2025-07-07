let
  pubkeys = import ../pubkeys.nix;
  inherit (pubkeys) users hosts;
in
{
  "users/helvetica.age".publicKeys =
    (builtins.attrValues users) ++ (builtins.attrValues (builtins.removeAttrs hosts [ "insomniac" ]));
  "users/insomniac.age".publicKeys = (builtins.attrValues users) ++ [ hosts.insomniac ];

  "vaultwarden.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "forgejo/mailer.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];
  "forgejo/admin.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "restic-vessel.age".publicKeys = (builtins.attrValues users) ++ [ hosts.vessel ];
  "restic-abacus.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "syncserver.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];

  "secure-boot/glacier.tar.age".publicKeys = (builtins.attrValues users) ++ [ hosts.glacier ];
  "secure-boot/abacus.tar.age".publicKeys = (builtins.attrValues users) ++ [ hosts.abacus ];
  "secure-boot/flamingo.tar.age".publicKeys = (builtins.attrValues users) ++ [ hosts.flamingo ];
  "secure-boot/vessel.tar.age".publicKeys = (builtins.attrValues users) ++ [ hosts.vessel ];
  "secure-boot/work.tar.age".publicKeys = (builtins.attrValues users) ++ [ hosts.work ];
}
