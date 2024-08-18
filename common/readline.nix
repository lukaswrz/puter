{
  environment.etc.inputrc.text = ''
    set editing-mode vi

    set completion-ignore-case on
    set enable-bracketed-paste on
    set show-all-if-ambiguous on
    set show-mode-in-prompt on

    set keymap vi-command
    Control-l: clear-screen
    Control-a: beginning-of-line
    Tab: menu-complete
    "\e[Z": complete

    set keymap vi-insert
    Control-l: clear-screen
    Control-a: beginning-of-line
    Tab: menu-complete
    "\e[Z": complete
  '';
}
