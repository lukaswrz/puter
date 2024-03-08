{
  config,
  lib,
  ...
}: {
  programs.direnv.enable = true;

  programs.bash.interactiveShellInit = ''
    eval "$(${lib.getExe config.programs.direnv.package} hook bash)"
  '';
}
