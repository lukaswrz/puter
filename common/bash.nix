{
  programs.bash.interactiveShellInit = ''
    shopt -s autocd globstar nullglob extglob checkwinsize
  '';
}
