{
  inputs,
  lib,
  pkgs,
  ...
}: let
  audiocomp = pkgs.writeShellApplication {
    name = "audiocomp";
    runtimeInputs = [
      pkgs.parallel
      pkgs.rsync
      pkgs.openssh
    ];
    text = let
      remoteDir = inputs.self.nixosConfigurations.abacus.config.services.navidrome.settings.MusicFolder;
      enc = pkgs.writeShellApplication {
        name = "enc";
        runtimeInputs = [
          pkgs.opusTools
        ];
        text = ''
          src=$(realpath -- "$1")
          dst=$src
          dst=''${dst%.flac}.opus
          dst=/srv/compmusic/''${dst#/srv/music/}

          if [[ -f "$dst" ]]; then
            exit
          fi

          mkdir --parents -- "$(dirname -- "$dst")"

          echo "encoding ''${src@Q} -> ''${dst@Q}" >&2
          exec opusenc --quiet --bitrate 96.000 -- "$src" "$dst"
        '';
      };
      clean = pkgs.writeShellApplication {
        name = "clean";
        text = ''
          del=$(realpath -- "$1")
          chk=$del
          chk=''${chk%.opus}.flac
          chk=/srv/music/''${chk#/srv/compmusic/}

          if [[ ! -f "$chk" ]]; then
            echo "deleting ''${del@Q}" >&2
            rm --force -- "$del"
          fi
        '';
      };
    in ''
      shopt -s globstar nullglob

      pushd /srv/music
      find . -name '*.flac' -print0 | parallel --null -- ${lib.getExe enc} {}
      popd

      pushd /srv/compmusic
      find . -name '*.flac' -exec ${clean} {} \;
      popd

      rsync --verbose --verbose --archive --update --delete --mkpath --exclude lost+found \
        --rsh 'ssh -i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' \
        -- /srv/compmusic/ root@wrz.one:${remoteDir}
    '';
  };
in {
  systemd.services.audiocomp = {
    description = "Compress and sync music";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
      ExecStart = lib.getExe audiocomp;
    };
  };

  systemd.timers.audiocomp = {
    description = "Compress and sync music daily";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
      Unit = "audiocomp.service";
    };
  };
}
