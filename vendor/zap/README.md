# Zap

Zap is a simple and mostly interactive disk utility:

```
# nix run git+https://hack.helveticanonstandard.net/helvetica/zap.git -- /dev/nvme0n1 
Do you want to create a boot partition? [y/N] y
Partition #1 contains a vfat signature.
Which label should the boot file system have? [BOOT] 
Do you want this disk to be encrypted? [y/N] y
Enter password: 
Re-enter password: 
Which label should the LUKS partition have? [cryptmain] 
Which name should the LUKS mapping have? [main] 
Which label should the file system have? [main]
# find /mnt
/mnt
/mnt/boot
/mnt/lost+found
```
