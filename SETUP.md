# Setup

## Install

```bash
nix run git+https://codeberg.org/helvetica/zap.git /path/to/disk
# TODO: Configure additional disks
mkdir -p /mnt/etc/ssh
cat > /mnt/etc/ssh/ssh_host_ed25519_key
chmod 600 /mnt/etc/ssh/ssh_host_ed25519_key
ssh-keygen -f /mnt/etc/ssh/ssh_host_ed25519_key -y > /mnt/etc/ssh/ssh_host_ed25519_key.pub
nixos-install --no-root-password --flake git+https://codeberg.org/helvetica/puter.git#hostname
```

## Enroll disk keys into TPM

```bash
systemd-cryptenroll /dev/sdX --tpm2-device=auto
```

## Secure boot

### rbw

### Generate keys

```bash
sudo sbctl create-keys
```

### Put keys into clipboard

```bash
sudo tar --create --directory /var/lib/sbctl . | base64 | wl-copy
```

### Use keys from clipboard

```bash
wl-paste | base64 --decode | sudo tar --extract --directory /var/lib/sbctl
```
