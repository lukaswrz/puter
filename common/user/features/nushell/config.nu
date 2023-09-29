$env.config = {
  show_banner: false

  rm: {
    always_trash: true
  }

  cd: {
    abbreviations: true
  }

  table: {
    index_mode: auto
  }

  history: {
    max_size: 1_000_000
  }

  completions: {
    case_sensitive: false
    algorithm: "fuzzy"
  }

  cursor_shape: {
    emacs: line
    vi_insert: block
    vi_normal: underscore
  }

  edit_mode: vi

  bracketed_paste: true

  shell_integration: true

  render_right_prompt_on_last_line: true

  hooks: {
    pre_prompt: [{ ||
      let direnv = (direnv export json | from json)
      let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
      $direnv | load-env
    }]
  }
}

def lsg [] { ls | sort-by type name -i | grid -c | str trim }
