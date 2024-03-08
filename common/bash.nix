{
  programs = {
    command-not-found.enable = false;

    bash = {
      blesh.enable = true;

      interactiveShellInit = ''
        shopt -s globstar
        shopt -s nullglob
        shopt -s extglob
        shopt -s checkwinsize

        bind 'set show-mode-in-prompt off'
      '';
    };
  };
}
