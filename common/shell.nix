{ config, ... }:
{
  programs = {
    fish.enable = true;

    bash.interactiveShellInit = ''
      shopt -s autocd globstar nullglob extglob checkwinsize
    '';

    starship = {
      enable = true;
      interactiveOnly = true;
      settings.format = "$all";
    };
  };

  users.defaultUserShell = config.programs.fish.package;
}
