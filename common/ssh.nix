{lib, ...}: {
  programs.ssh.startAgent = true;

  environment.etc."ssh/ssh_config".text = lib.mkAfter ''
    Compression yes
    ServerAliveInterval 60
  '';
}
