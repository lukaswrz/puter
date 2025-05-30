# :snowflake: puter

This is my cobbled together NixOS configuration. There are many like it, but this one is mine. Copy at your own risk.

## Structure

- common: Sane defaults that make sense to use for every host.
- modules: Regular NixOS modules.
- profiles: Higher-level NixOS modules that conform to different roles that a host may have.
- packages: Packages that I couldn't fit anywhere else.
- secrets: Agenix secrets.
- hosts: Hosts exposed in `nixosConfigurations`.
- pubkeys.nix: Nix expression with all my SSH public keys, used for OpenSSH, Agenix and Restic.
- lib.nix: Nixpkgs' lib with some extra functionality.

## Ports

- 80X0: Public HTTP services that are proxied through nginx
- 40X0: Syncthing instances (4000 being the system instance, subsequent ones are for individual users)

## Installation

```bash
nix run git+https://codeberg.org/helvetica/puter.git#disk /path/to/disk
# TODO: Configure additional disks
mkdir -p /mnt/etc/ssh
cat > /mnt/etc/ssh/ssh_host_ed25519_key
chmod 600 /mnt/etc/ssh/ssh_host_ed25519_key
ssh-keygen -f /mnt/etc/ssh/ssh_host_ed25519_key -y > /mnt/etc/ssh/ssh_host_ed25519_key.pub
nixos-install --no-root-password --flake git+https://codeberg.org/helvetica/puter.git#hostname
```

## systemd-cryptenroll

```bash
systemd-cryptenroll /dev/sdX --tpm2-device=auto
```

## Create tar for sbctl

```bash
sudo sbctl create-keys
sudo tar --create --directory /var/lib/sbctl . | agenix -e secure-boot/hostname.tar.age
```

## TODO

- [ ] Lanzaboote
- [ ] Monitoring
- [ ] Rom sync
- [ ] insomniac backups
- [ ] nginx websites
