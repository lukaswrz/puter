{
  lib,
  pkgs,
  ...
}:
{
  #services.rsync = {
  #  enable = true;

  #  commonArgs = let
  #    rsh = "${lib.getExe pkgs.openssh} -i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
  #  in [
  #    "--verbose"
  #    "--verbose"
  #    "--archive"
  #    "--update"
  #    "--delete"
  #    "--mkpath"
  #    "--exclude"
  #    "lost+found"
  #    "--rsh"
  #    rsh
  #  ];
  #};
}
