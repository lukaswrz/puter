{
  programs.bash.interactiveShellInit = ''
    shopt -s autocd globstar failglob extglob checkwinsize
  '';
}
