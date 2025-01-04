#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

progname=$0

warn() {
    local line
    for line in "$@"; do
        echo "$progname: $line" 1>&2
    done
}

error() {
    warn "$@"

    exit 1
}

args=$(getopt --options f:o:t:v --longoptions=flake:,on:,to:,verbose --name "$progname" -- "$@")

eval set -- "$args"

flags=(
    --refresh
    --use-remote-sudo
    --no-write-lock-file
)
verbose=false
while true; do
    case $1 in
    (-f | --flake)
        flake=$2
        shift 2
        ;;
    (-o | --on)
        flags+=(--build-host "$2")
        shift 2
        ;;
    (-t | --to)
        host=$2
        flags+=(--target-host "$host")
        shift 2
        ;;
    (-v | --verbose)
        flags+=(--verbose)
        verbose=true
        shift
        ;;
    (--)
        shift
        break
        ;;
    esac
done

if [[ ! -v flake ]]; then
    if [[ -v host ]]; then
        hostname=$(ssh -- "$host" hostname)
    else
        hostname=$(hostname)
    fi
    flake=git+https://forgejo@tea.wrz.one/lukas/puter.git#$hostname
fi

flags+=(--flake "$flake")

if (( $# == 0 )); then
    error 'a subcommand is required'
fi

run() {
    cmd=(nixos-rebuild "${flags[@]}" "$@")

    if "$verbose"; then
        warn "running ${cmd[*]}"
    fi

    "${cmd[@]}"
}

sub=$1

case $sub in
    (s | switch)
        shift

        if (( $# > 0 )); then
            error 'too many arguments'
        fi

        run switch
        ;;
    (b | boot)
        shift

        if (( $# > 0 )); then
            error 'too many arguments'
        fi

        run boot
        ;;
    (*)
        error 'invalid subcommand'
        ;;
esac
