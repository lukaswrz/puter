# ❄️ puter

This is my cobbled together NixOS configuration. There are many like it, but this one is mine. Copy at your own risk.

## Structure

- common: Sane defaults that make sense to use for every host.
- modules: Regular NixOS modules.
- profiles: Higher-level NixOS modules that conform to different roles that a host may have.
- secrets: Agenix secrets.
- hosts: Hosts exposed in `nixosConfigurations`.
- pubkeys.nix: Nix expression with all my SSH public keys, used for OpenSSH, Agenix and Restic.

## Services

### General rules

- Lower X = more important.
- Fewer services = more better.

### Ports

- 40X0: Syncthing instances behind Tailscale
  - 4000: The system instance
  - Subsequent ones are for individual users
- 80X0: Public HTTP services that are proxied through nginx
  - 8000: Headscale
  - 8010: Vaultwarden
  - 8020: Forgejo
  - 8030: Continuwuity
  - 8040: Navidrome

## TODOs

- Radicale
- Facter (hosts left: glacier)
- Remaining emails
