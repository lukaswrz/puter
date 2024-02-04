if status is-interactive
  stty -ixon
  set fish_greeting

  fish_vi_key_bindings

  bind \ee edit_command_buffer

  set fish_cursor_default     block      blink
  set fish_cursor_insert      line       blink
  set fish_cursor_replace_one underscore blink
  set fish_cursor_visual      block

  abbr --add --global l ls
  abbr --add --global lsa ls -a
  abbr --add --global la ls -a
  abbr --add --global lsl ls -l
  abbr --add --global ll ls -l
  abbr --add --global lsla ls -la
  abbr --add --global lla ls -la
  abbr --add --global cp cp -n
  abbr --add --global cpr cp -rn
  abbr --add --global mv mv -n
  abbr --add --global rm rm -i
  abbr --add --global rmr rm -ri
  abbr --add --global rr rm -ri
  abbr --add --global v hx
  abbr --add --global g git
  abbr --add --global gc git commit
  abbr --add --global gco git checkout
  abbr --add --global gs git status
  abbr --add --global gd git diff
  abbr --add --global gdh git diff HEAD
  abbr --add --global ga git add
  abbr --add --global s sudo
  abbr --add --global g grep
  abbr --add --global gn grep -n
  abbr --add --global gin grep -in
  abbr --add --global grin grep -rin
  abbr --add --global df df -h
  abbr --add --global du du -h
  abbr --add --global c cd
  abbr --add --global cd. cd .
  abbr --add --global cd.. cd ..

  function ls; command ls --classify=auto --color=auto $argv; end
  function ffmpeg; command ffmpeg -hide_banner $argv; end
  function ffprobe; command ffprobe -hide_banner $argv; end
  function ffplay; command ffplay -hide_banner $argv; end

  function fish_prompt
    if test $CMD_DURATION -gt 10000
      echo -ne '\a'
    end

    set -l __last_command_exit_status $status

    if not set -q -g __fish_arrow_functions_defined
      set -g __fish_arrow_functions_defined
      function _git_branch_name
        set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
        if set -q branch[1]
          echo (string replace -r '^refs/heads/' '' $branch)
        else
          echo (git rev-parse --short HEAD 2>/dev/null)
        end
      end

      function _is_git_dirty
        not command git diff-index --cached --quiet HEAD -- &>/dev/null
        or not command git diff --no-ext-diff --quiet --exit-code &>/dev/null
      end

      function _is_git_repo
        type -q git
        or return 1
        git rev-parse --git-dir >/dev/null 2>&1
      end

      function _hg_branch_name
        echo (hg branch 2>/dev/null)
      end

      function _is_hg_dirty
        set -l stat (hg status -mard 2>/dev/null)
        test -n "$stat"
      end

      function _is_hg_repo
        fish_print_hg_root >/dev/null
      end

      function _repo_branch_name
        _$argv[1]_branch_name
      end

      function _is_repo_dirty
        _is_$argv[1]_dirty
      end

      function _repo_type
        if _is_hg_repo
          echo hg
          return 0
        else if _is_git_repo
          echo git
          return 0
        end
        return 1
      end
    end

    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l green (set_color -o green)
    set -l blue (set_color -o blue)
    set -l normal (set_color normal)

    set -l prompt_color "$green"
    if test $__last_command_exit_status != 0
      set prompt_color "$red"
    end

    set -l prompt "$prompt_color\$"
    if fish_is_root_user
      set prompt "$prompt_color#"
    end

    set -l cwd $cyan(basename -- (prompt_pwd))

    set -l repo_info
    if set -l repo_type (_repo_type)
      set -l repo_branch $red(_repo_branch_name $repo_type)
      set repo_info "$blue $repo_type:($repo_branch$blue)"

      if _is_repo_dirty $repo_type
        set -l dirty "$yellow ✗"
        set repo_info "$repo_info$dirty"
      end
    end

    echo -n -s -- $cwd $repo_info ' ' $prompt ' '$normal
  end

  direnv hook fish | source
end
