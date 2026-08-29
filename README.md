# ❄️ puter

This is my cobbled together NixOS configuration. There are many like it, but this one is mine. Copy at your own risk.

## Structure

- common: Sane defaults that make sense to use for every host.
- modules: Regular NixOS modules.
- profiles: Higher-level NixOS modules that conform to different roles that a host may have.
- secrets: Agenix secrets.
- hosts: Hosts exposed in `nixosConfigurations`.
- pubkeys.nix: Nix expression with all my SSH public keys, used for OpenSSH, Agenix and Restic.

## TODO

* Tailscale profile
* Public services
* Caddy/nginx
