{
  programs.qutebrowser = {
    enable = true;
    extraConfig = ''
      from locale import getdefaultlocale
      from os import environ
      from re import match
      from pathlib import Path

      config.load_autoconfig()

      c.aliases = {
          "o": "open",
          "q": "quit",
          "w": "session-save",
          "wq": "quit --save",
          "adblock-toggle": "config-cycle -t content.blocking.enabled",
          "incognito": "open --private",
          "mpv": "spawn --detach mpv {url}",
      }

      c.colors.webpage.bg = "black"

      # TODO
      # c.editor.command = [
      #     "neovide",
      #     "--nofork",
      #     "--wayland-app-id",
      #     "neovidefloat",
      #     "--",
      #     "+normal {line}G{column0}l",
      #     "--",
      #     "{file}",
      # ]

      c.editor.encoding = "utf-8"

      config.bind("td", "config-cycle colors.webpage.darkmode.enabled;; restart")

      c.tabs.show = "multiple"

      c.tabs.tabs_are_windows = True

      c.content.local_content_can_access_remote_urls = True

      c.url.default_page = Path("${./start.html}").as_uri()

      c.url.start_pages = [c.url.default_page]

      c.url.searchengines = {
          "DEFAULT": "https://www.google.com/search?q={}",
          "g": "https://www.google.com/search?q={}",
          "ddg": "https://lite.duckduckgo.com/lite?q={}",
          "wt": "https://en.wiktionary.org/w/index.php?search={}",
          "w": "https://en.wikipedia.org/w/index.php?search={}",
          "bs": "https://search.brave.com/search?q={}",
          "aur": "https://aur.archlinux.org/packages/?SB=p&SO=d&O=0&K={}",
          "gh": "https://github.com/search?q={}",
          "gist": "https://gist.github.com/search?q={}",
          "dd": "https://thefreedictionary.com/{}",
          "dr": "https://search.disroot.org/?q={}",
      }

      try:
          l = getdefaultlocale()[0]
          if l is None or l in ("C", "POSIX"):
              raise ValueError

          rematch = match(r"([a-z]+)(_([A-Z]+)?)", l)
          if rematch is None:
              raise ValueError

          language = rematch[1]

          try:
              locale = rematch[3]
              c.content.headers.accept_language = f"{language}-{locale},{language};q=0.9,en-{locale},en;q=0.8,en-US,en;q=0.7,*;q=0.6"
          except IndexError:
              c.content.headers.accept_language = f"{language};q=0.9,en-US,en;q=0.8,*;q=0.7"
      except:
          c.content.headers.accept_language = "en-US,en;q=0.9"

      # TODO
      # c.colors.webpage.preferred_color_scheme = "dark"

      base00 = "#1f2022"
      base01 = "#282828"
      base02 = "#444155"
      base03 = "#585858"
      base04 = "#b8b8b8"
      base05 = "#a3a3a3"
      base06 = "#e8e8e8"
      base07 = "#f8f8f8"
      base08 = "#f2241f"
      base09 = "#ffa500"
      base0A = "#b1951d"
      base0B = "#67b11d"
      base0C = "#2d9574"
      base0D = "#4f97d7"
      base0E = "#a31db1"
      base0F = "#b03060"

      c.colors.completion.fg = base05
      c.colors.completion.odd.bg = base01
      c.colors.completion.even.bg = base00
      c.colors.completion.category.fg = base0A
      c.colors.completion.category.bg = base00
      c.colors.completion.category.border.top = base00
      c.colors.completion.category.border.bottom = base00
      c.colors.completion.item.selected.fg = base05
      c.colors.completion.item.selected.bg = base02
      c.colors.completion.item.selected.border.top = base02
      c.colors.completion.item.selected.border.bottom = base02
      c.colors.completion.item.selected.match.fg = base0B
      c.colors.completion.match.fg = base0B
      c.colors.completion.scrollbar.fg = base05
      c.colors.completion.scrollbar.bg = base00
      c.colors.contextmenu.disabled.bg = base01
      c.colors.contextmenu.disabled.fg = base04
      c.colors.contextmenu.menu.bg = base00
      c.colors.contextmenu.menu.fg = base05
      c.colors.contextmenu.selected.bg = base02
      c.colors.contextmenu.selected.fg = base05
      c.colors.downloads.bar.bg = base00
      c.colors.downloads.start.fg = base00
      c.colors.downloads.start.bg = base0D
      c.colors.downloads.stop.fg = base00
      c.colors.downloads.stop.bg = base0C
      c.colors.downloads.error.fg = base08
      c.colors.hints.fg = base00
      c.colors.hints.bg = base0A
      c.colors.hints.match.fg = base05
      c.colors.keyhint.fg = base05
      c.colors.keyhint.suffix.fg = base05
      c.colors.keyhint.bg = base00
      c.colors.messages.error.fg = base00
      c.colors.messages.error.bg = base08
      c.colors.messages.error.border = base08
      c.colors.messages.warning.fg = base00
      c.colors.messages.warning.bg = base0E
      c.colors.messages.warning.border = base0E
      c.colors.messages.info.fg = base05
      c.colors.messages.info.bg = base00
      c.colors.messages.info.border = base00
      c.colors.prompts.fg = base05
      c.colors.prompts.border = base00
      c.colors.prompts.bg = base00
      c.colors.prompts.selected.bg = base02
      c.colors.prompts.selected.fg = base05
      c.colors.statusbar.normal.fg = base0B
      c.colors.statusbar.normal.bg = base00
      c.colors.statusbar.insert.fg = base00
      c.colors.statusbar.insert.bg = base0D
      c.colors.statusbar.passthrough.fg = base00
      c.colors.statusbar.passthrough.bg = base0C
      c.colors.statusbar.private.fg = base00
      c.colors.statusbar.private.bg = base01
      c.colors.statusbar.command.fg = base05
      c.colors.statusbar.command.bg = base00
      c.colors.statusbar.command.private.fg = base05
      c.colors.statusbar.command.private.bg = base00
      c.colors.statusbar.caret.fg = base00
      c.colors.statusbar.caret.bg = base0E
      c.colors.statusbar.caret.selection.fg = base00
      c.colors.statusbar.caret.selection.bg = base0D
      c.colors.statusbar.progress.bg = base0D
      c.colors.statusbar.url.fg = base05
      c.colors.statusbar.url.error.fg = base08
      c.colors.statusbar.url.hover.fg = base05
      c.colors.statusbar.url.success.http.fg = base0C
      c.colors.statusbar.url.success.https.fg = base0B
      c.colors.statusbar.url.warn.fg = base0E
      c.colors.tabs.bar.bg = base00
      c.colors.tabs.indicator.start = base0D
      c.colors.tabs.indicator.stop = base0C
      c.colors.tabs.indicator.error = base08
      c.colors.tabs.odd.fg = base05
      c.colors.tabs.odd.bg = base01
      c.colors.tabs.even.fg = base05
      c.colors.tabs.even.bg = base00
      c.colors.tabs.pinned.even.bg = base0C
      c.colors.tabs.pinned.even.fg = base07
      c.colors.tabs.pinned.odd.bg = base0B
      c.colors.tabs.pinned.odd.fg = base07
      c.colors.tabs.pinned.selected.even.bg = base02
      c.colors.tabs.pinned.selected.even.fg = base05
      c.colors.tabs.pinned.selected.odd.bg = base02
      c.colors.tabs.pinned.selected.odd.fg = base05
      c.colors.tabs.selected.odd.fg = base05
      c.colors.tabs.selected.odd.bg = base02
      c.colors.tabs.selected.even.fg = base05
      c.colors.tabs.selected.even.bg = base02
      c.colors.webpage.bg = base00
    '';
  };
}
