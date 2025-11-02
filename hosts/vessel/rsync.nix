{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  tailnet = inputs.self.nixosConfigurations.abacus.config.services.headscale.settings.dns.base_domain;
in
{
  services.rsync = {
    enable = true;
    jobs =
      let
        ssh = "${lib.getExe pkgs.openssh} -i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      in
      {
        vault-sync = {
          sources = [ "/srv/vault/" ];
          destination = "/srv/sync";
          inhibit = [ "sleep" ];
          settings = {
            archive = true;
            delete = true;
            mkpath = true;
            checksum = true;
            verbose = [
              true
              true
            ];
            exclude = "lost+found/";
          };
          timerConfig = {
            OnCalendar = "hourly";
            Persistent = true;
          };
        };

        roms-kaleidoscope = {
          sources = [ "/srv/vault/roms/" ];
          destination = "insomniac@kaleidoscope.${tailnet}:~/Roms";
          inhibit = [ "sleep" ];
          settings = {
            archive = true;
            delete = true;
            mkpath = true;
            checksum = true;
            verbose = [
              true
              true
            ];
            rsh = ssh;
          };
          timerConfig = {
            OnCalendar = "hourly";
            Persistent = true;
          };
        };

        movies-kaleidoscope = {
          sources = [ "/srv/vault/movies/" ];
          destination = "insomniac@kaleidoscope.${tailnet}:~/Videos/Movies";
          inhibit = [ "sleep" ];
          settings = {
            archive = true;
            delete = true;
            mkpath = true;
            checksum = true;
            verbose = [
              true
              true
            ];
            rsh = ssh;
          };
          timerConfig = {
            OnCalendar = "hourly";
            Persistent = true;
          };
        };
      };
  };
}
