{ config, ... }:
{
  programs.fish.enable = true;
  users.defaultUserShell = config.programs.fish.package;
}
