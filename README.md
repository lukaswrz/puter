# ✨ puter ✨

## Partitioning with labels

### Boot

```bash
mkfs.vfat -F 32 -n BOOT $bootpart
```

### Swap

```bash
mkswap -L swap $swappart
swapon $swappart
```

### Root

```bash
cryptsetup luksFormat -yv --label cryptroot $rootpart
cryptsetup open $rootpart cryptroot
mkfs.btrfs /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt

btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix

umount /mnt

mount -o subvol=root,compress=zstd,noatime /dev/mapper/cryptroot /mnt

mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/cryptroot /mnt/nix

mkdir /mnt/boot
mount $bootpart /mnt/boot
```
