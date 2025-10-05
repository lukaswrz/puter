# Flendor

Super simple flake input vendoring.

Example `flendor.json`:

```json
{
  "vendor": "vendor",
  "flakes": {
    "musicomp": "git+https://forgejo.helveticanonstandard.net/helvetica/musicomp.git",
    "hxwrap": "git+https://forgejo.helveticanonstandard.net/helvetica/hxwrap.git",
    "forgesync": "git+https://forgejo.helveticanonstandard.net/helvetica/forgesync.git",
    "nini": "git+https://forgejo.helveticanonstandard.net/helvetica/nini.git",
    "xenumenu": "git+https://forgejo.helveticanonstandard.net/helvetica/xenumenu.git",
    "mympv": "git+https://forgejo.helveticanonstandard.net/helvetica/mympv.git"
  }
}
```

Example usage:

```
$ ./flendor
./flendor: copying flake git+https://forgejo.helveticanonstandard.net/helvetica/forgesync.git to vendor/forgesync
./flendor: copying flake git+https://forgejo.helveticanonstandard.net/helvetica/hxwrap.git to vendor/hxwrap
./flendor: copying flake git+https://forgejo.helveticanonstandard.net/helvetica/musicomp.git to vendor/musicomp
./flendor: copying flake git+https://forgejo.helveticanonstandard.net/helvetica/mympv.git to vendor/mympv
./flendor: copying flake git+https://forgejo.helveticanonstandard.net/helvetica/nini.git to vendor/nini
./flendor: copying flake git+https://forgejo.helveticanonstandard.net/helvetica/xenumenu.git to vendor/xenumenu
./flendor: removing old flake at vendor/asdf
./flendor: removing old flake at vendor/hjkl
```

## Why?

I personally just use this to vendor my own flakes in my NixOS configuration, so that if my Forgejo server ever stops working, I still have the possibility to rebuild its configuration without much hassle.
But I'm sure there are other use cases as well.
