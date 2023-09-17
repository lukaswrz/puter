# ✨ puter ✨

## Setup

```bash
fdisk $disk

mkfs.vfat -F 32 -n BOOT $boot

cryptsetup luksFormat -yv --label cryptmain $main
cryptsetup open $main main
mkfs.btrfs /dev/mapper/main

mount /dev/mapper/main /mnt

for vol in nix persist home log; do btrfs subvol create /mnt/$vol; done

umount /mnt

mount -t tmpfs -o size=8G,mode=755 tmpfs /mnt

mkdir -p /mnt/{boot,nix,persist,home,var/log}

for vol in nix persist home var/log; do mount -o subvol=$(basename $vol),compress=zstd,noatime /dev/mapper/main /mnt/$vol; done

mount $boot /mnt/boot

nixos-install --no-root-password --flake github:lukaswrz/puter#system
```

```bash
fdisk $disk

mkfs.vfat -F 32 -n BOOT $boot

mkfs.btrfs -L main $main

mount $main /mnt

for vol in nix persist log; do btrfs subvol create /mnt/$vol; done

umount /mnt

mount -t tmpfs -o size=2G,mode=755 tmpfs /mnt

mkdir -p /mnt/{boot,nix,persist,home,var/log}

for vol in nix persist var/log; do mount -o subvol=$(basename $vol),compress=zstd,noatime $main /mnt/$vol; done

mount -t tmpfs -o size=2G tmpfs /mnt/home

mount $boot /mnt/boot

nixos-install --no-root-password --flake github:lukaswrz/puter#system
```
