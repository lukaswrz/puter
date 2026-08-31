# abacus

Public server.

## TODO

- [soju](https://codeberg.org/emersion/soju)

## Attic

```nix
{ secretsPath, config, ... }:
{
  age.secrets.attic.file = secretsPath + /attic.age;
  services.atticd = {
    enable = true;
    environmentFile = config.age.secrets.attic.path;

    settings = {
      listen = "[::]:6000";

      jwt = { };

      chunking = {
        nar-size-threshold = 64 * 1024;
        min-size = 16 * 1024;
        avg-size = 64 * 1024;
        max-size = 256 * 1024;
      };
    };
  };
}
```
