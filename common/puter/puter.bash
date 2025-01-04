#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

progname=$0

error() {
    for line in "$@"; do
        echo "$progname: $line" 1>&2
    done

    exit 1
}

args=$(getopt --options f:o:t: --longoptions=flake:,on:,to: --name "$progname" -- "$@")

eval set -- "$args"

host=localhost
flags=(
    --refresh
    --use-remote-sudo
    --no-write-lock-file
)
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
        shift
        ;;
    (--)
        shift
        break
        ;;
    esac
done

if [[ ! -v flake ]]; then
    flake=git+https://forgejo@tea.wrz.one/lukas/puter.git#$(ssh -- "$host" hostname)
fi

flags+=(--flake "$flake")

if (( $# == 0 )); then
    error 'a subcommand is required'
fi

sub=$1

cmd=(nixos-rebuild "${flags[@]}")

case $sub in
    (s | switch)
        shift

        if (( $# > 0 )); then
            error 'too many arguments'
        fi

        cmd+=(switch)
        echo "${cmd[@]}"
        "${cmd[@]}"
        ;;
    (b | boot)
        shift

        if (( $# > 0 )); then
            error 'too many arguments'
        fi

        cmd+=(boot)
        echo "${cmd[@]}"
        "${cmd[@]}"
        ;;
    (*)
        error 'invalid subcommand'
        ;;
esac
