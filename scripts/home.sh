shopt -s nullglob

opts=$(getopt --options n:e: --longoptions=name:,email: --name "$0" -- "$@")

eval set -- "$opts"

name=
email=
while true; do
  case "$1" in
  -n | --name)
    name=$2
    shift 2
    ;;
  -e | --email)
    email=$2
    shift 2
    ;;
  --)
    shift
    break
    ;;
  esac
done

choices=("$@")
shift "$#"

function chose() {
  if [[ ${#choices[@]} == 0 ]]; then
    return 0
  fi
  local arg
  for arg in "$@"; do
    local choice
    for choice in "${choices[@]}"; do
      if [[ "$arg" == "$choice" ]]; then
        return 0
      fi
    done
  done
  return 1
}

if chose git; then
  gitconfig=${XDG_CONFIG_HOME:-$HOME/.config}/git/config

  if [[ -n $name ]]; then
    GIT_CONFIG_GLOBAL=$gitconfig git config --global -- user.name "$name"
  fi
  if [[ -n $email ]]; then
    GIT_CONFIG_GLOBAL=$gitconfig git config --global -- user.email "$email"
  fi

  gitignore=$(GIT_CONFIG_GLOBAL=$gitconfig git config --global --get core.excludesFile 2>/dev/null || printf '%s\n' "${XDG_CONFIG_HOME:-$HOME/.config}/git/ignore")
  mkdir --parents -- "$(dirname -- "$gitignore")"
  cat <<EOF >"$gitignore"
.idea/
.vscode/
.iml
*.sublime-workspace

node_modules/
vendor/

log/
*.log

__pycache__/
zig-cache/

*.com
*.class
*.dll
*.exe
*.o
*.so
*.pyc
*.pyo

*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip
*.msi

*.sqlite
*.sqlite3
*.db
*.db3
*.s3db
*.sl3
*.rdb

*.bak
*.swp
*.swo
*~
*#

zig-out/

.direnv/
EOF
  GIT_CONFIG_GLOBAL=$gitconfig git config --global -- core.excludesFile "$gitignore"
fi

if chose mpv; then
  if flatpak info io.mpv.Mpv >/dev/null 2>&1; then
mpvconf=$HOME/.var/app/io.mpv.Mpv/config/mpv/mpv.conf
mkdir --parents -- "$(dirname -- "$mpvconf")"
cat <<EOF >"$mpvconf"
force-window=immediate
keep-open=yes
save-position-on-quit=yes

screenshot-template="%f_%wH%wM%wS.%wT"

scale=ewa_lanczossharp
cscale=ewa_lanczossharp
tscale=oversample

interpolation=yes
video-sync=display-resample
vo=gpu
profile=gpu-hq
EOF
  fi
fi

if chose firefox; then
  if flatpak info org.mozilla.firefox >/dev/null 2>&1; then
    ffparent=$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox
    for profile in "$ffparent"/*.default "$ffparent"/*.default-release; do
      userjs=$profile/user.js
      cat <<EOF >"$userjs"
// Forms
user_pref('signon.prefillForms', false);
user_pref('signon.rememberSignons', false);
user_pref('signon.autofillForms', false);
user_pref('signon.formlessCapture.enabled', false);
user_pref('browser.formfill.enable', false);

// Pocket
user_pref('extensions.pocket.enabled', false);

// Sponsorships
user_pref('browser.newtabpage.activity-stream.showSponsored', false);
user_pref('browser.newtabpage.activity-stream.showSponsoredTopSites', false);
user_pref('browser.newtabpage.activity-stream.feeds.section.topstories', false);
user_pref('browser.newtabpage.activity-stream.feeds.topsites', false);
user_pref('browser.newtabpage.activity-stream.section.highlights.includeBookmarks', false);
user_pref('browser.newtabpage.activity-stream.section.highlights.includeDownloads', false);
user_pref('browser.newtabpage.activity-stream.section.highlights.includeVisited', false);

// VA-API (https://bugzilla.mozilla.org/show_bug.cgi?id=1610199)
user_pref('media.ffmpeg.vaapi.enabled', true);

// Telemetry
user_pref('toolkit.telemetry.unified', false);
user_pref('toolkit.telemetry.enabled', false);
user_pref('toolkit.telemetry.server', 'data:,');
user_pref('toolkit.telemetry.archive.enabled', false);
user_pref('toolkit.telemetry.newProfilePing.enabled', false);
user_pref('toolkit.telemetry.shutdownPingSender.enabled', false);
user_pref('toolkit.telemetry.updatePing.enabled', false);
user_pref('toolkit.telemetry.bhrPing.enabled', false);
user_pref('toolkit.telemetry.firstShutdownPing.enabled', false);
user_pref('toolkit.telemetry.coverage.opt-out', true);
user_pref('toolkit.coverage.opt-out', true);
user_pref('toolkit.coverage.endpoint.base', '');
user_pref('browser.ping-centre.telemetry', false);
user_pref('app.shield.optoutstudies.enabled', false);
user_pref('app.normandy.enabled', false);
user_pref('app.normandy.api_url', '');
user_pref('breakpad.reportURL', '');
user_pref('browser.tabs.crashReporting.sendReport', false);
user_pref('browser.crashReports.unsubmittedCheck.autoSubmit2', false);

// Referer
user_pref("network.http.referer.XOriginPolicy", 1);
user_pref("network.http.referer.XOriginTrimmingPolicy", 0);
EOF
    done
  fi
fi

if chose bash; then
  bashrc=$HOME/.bashrc
  ln --force --symbolic -- "$PWD/home/bash/bashrc" "$bashrc"
fi

if chose fish; then
  fishconfig=${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish
  mkdir --parents -- "$(dirname -- "$fishconfig")"
  ln --force --symbolic -- "$PWD/home/fish/config.fish" "$fishconfig"
fi

if chose helix; then
  helixdir=${XDG_CONFIG_HOME:-$HOME/.config}/helix
  rm --recursive --force -- "$helixdir"
  ln --force --symbolic -- "$PWD/home/helix" "$helixdir"
fi
