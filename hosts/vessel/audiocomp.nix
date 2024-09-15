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
    ];
    text = let
      remoteDir = inputs.self.nixosConfigurations.abacus.config.services.navidrome.settings.MusicFolder;
      enc = pkgs.writeShellApplication {
        name = "enc";
        runtimeInputs = [
          pkgs.opusTools
        ];
        text = ''
          src="$1"
          dst=''${src%.flac}.opus
          dst=/srv/compmusic/''${dst#./}

          if [[ -f "$dst" ]]; then
            exit
          fi

          mkdir --parents -- "$(dirname -- "$dst")"
          exec opusenc --quiet --bitrate 96.000 -- {} "$dst"
        '';
      };
    in ''
      cd /srv/music
      find . -name '*.flac' -print0 | parallel --null -- '${lib.getExe enc} {}'

      rsync --verbose --verbose --archive --update --delete --mkpath --exclude lost+found \
        --rsh 'ssh -i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' \
        -- /srv/compmusic/ root@wrz.one:${remoteDir}
    '';
  };
in {
  # systemd.services.audiocomp = {
  #   description = "Compress and sync music";
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "root";
  #     Group = "root";
  #     ExecStart = lib.getExe audiocomp;
  #   };
  # };
}