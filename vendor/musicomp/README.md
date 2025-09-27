# musicomp

A simple music compression tool.

If you're anything like me, you obtain music in FLAC format for archival and compress it down to a codec such as Opus for actual listening.
musicomp exists to automate the continuous compression work that would otherwise have to be done manually.

It:

* scans the source and destination directories,
* makes sure the content is properly synchronized (i.e., there are no tracks in destination that don't exist in source and vice versa), and
* compresses the music from FLAC to Opus in parallel.

## Dependencies

musicomp requires `opusenc` in `$PATH` in order to function.
The Nix package wraps musicomp to include `opusenc` out of the box.

## NixOS

A NixOS module is provided within this flake.
Here's an example of how to use it:

```nix
{
  self,
  lib,
  pkgs,
  ...
}: {
  services.musicomp.jobs.main = {
    music = "/srv/music";
    comp = "/srv/compmusic";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    inhibit = ["sleep"];
    post = let
      remoteDir = "/my/music/folder";
      rsyncExe = lib.getExe pkgs.rsync;
      rsh = "${lib.getExe pkgs.openssh} -i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
    in ''
      ${rsyncExe} \
        --archive \
        --recursive \
        --delete \
        --update \
        --mkpath \
        --verbose --verbose \
        --exclude lost+found \
        --rsh ${lib.escapeShellArg rsh} \
        /srv/compmusic/ root@my.server:${remoteDir}
    '';
  };
}
```
