# vessel

## File systems

- Main: White, 1TB, for the system and some extra storage
- Vault: Black, 2TB, primary for all data
- Void: Green, 1TB, for data that's not as important
- Sync: Red, 2TB, synced from the vault

## ACLs for Syncthing

```
setfacl --recursive --default --modify user:syncthing:rwx /srv/{vault,void}
```
