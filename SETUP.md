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

### Create keys

```bash
sudo sbctl create-keys
sudo tar --create --directory /var/lib/sbctl . | base64
```

### Use keys (wl-paste)

```bash
wl-paste | base64 --decode | sudo tar --extract
```

### Use keys (rbw)

```bash
rbw config set email EMAIL
rbw config set base_url BASE_URL
rbw login
rbw unlock
rbw get --folder 'Secure Boot' HOST | base64 --decode | sudo tar --extract
```
