# :snowflake: puter

This is my cobbled together NixOS configuration. There are many like it, but this one is mine. Copy at your own risk.

## Structure

- common: Sane defaults that make sense to use for every host.
- modules: Regular NixOS modules.
- profiles: Higher-level NixOS modules that conform to different roles that a host may have.
- secrets: Agenix secrets.
- hosts: Hosts exposed in `nixosConfigurations`.
- pubkeys.nix: Nix expression with all my SSH public keys, used for OpenSSH, Agenix and Restic.

## Services

General rules:

- Lower X = more important.
- Fewer services = more better.

Ports:

- 40X0: Syncthing instances behind Tailscale
  - 4000: The system instance
  - Subsequent ones are for individual users
- 60X0: Services behind Tailscale
  - 6000: Navidrome
  - 6010: Miniflux
- 80X0: Public HTTP services that are proxied through nginx
  - 8000: Headscale
  - 8010: Vaultwarden
  - 8020: Forgejo

## Installation

```bash
nix run git+https://codeberg.org/helvetica/zap.git /path/to/disk
# TODO: Configure additional disks
mkdir -p /mnt/etc/ssh
cat > /mnt/etc/ssh/ssh_host_ed25519_key
chmod 600 /mnt/etc/ssh/ssh_host_ed25519_key
ssh-keygen -f /mnt/etc/ssh/ssh_host_ed25519_key -y > /mnt/etc/ssh/ssh_host_ed25519_key.pub
nixos-install --no-root-password --flake git+https://codeberg.org/helvetica/puter.git#hostname
```

## Enroll disk keys

```bash
systemd-cryptenroll /dev/sdX --tpm2-device=auto
```

## Secure boot (TODO)

```bash
sudo sbctl create-keys
sudo tar --create --directory /var/lib/sbctl . | base64
```

```bash
cat keys | base64 --decode | sudo tar --extract
```

## TODO

- [ ] Monitoring
- [ ] Rom sync
- [ ] kaleidoscope backups
- [ ] nginx websites
