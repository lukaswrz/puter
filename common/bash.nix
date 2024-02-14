{
  lib,
  pkgs,
  ...
}: {
  programs = {
    direnv.enable = true;
    command-not-found.enable = false;

    bash = {
      promptInit = ''
        if [[ -v SSH_CLIENT && -v SSH_CONNECTION && -v SSH_TTY ]]; then
          PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        else
          PS1='\[\033[01;34m\]\w\[\033[00m\]\$ '
        fi
      '';
      interactiveShellInit = ''
        shopt -s histappend
        HISTCONTROL='ignoredups:ignorespace'
        HISTSIZE=1000
        HISTFILESIZE=10000

        shopt -s globstar
        shopt -s nullglob
        shopt -s extglob

        shopt -s checkwinsize

        eval "$(${lib.getExe pkgs.direnv} hook bash)"
      '';
    };
  };
}
