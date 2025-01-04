#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

progname=$0

error() {
    for line in "$@"; do
        printf '%s\n' "$progname: $line" 1>&2
    done

    exit 1
}

args=$(getopt --options f --longoptions=flake: --name "$progname" -- "$@")

eval set -- "$args"

flake=git+https://forgejo@tea.wrz.one/lukas/puter.git#$(hostname)
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
        flags+=(--target-host "$2")
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

if (( $# == 0 )); then
    error 'a subcommand is required'
fi

subcommand=$1

case $subcommand in
    (s | switch)
        shift

        if (( $# > 0 )); then
            error 'too many arguments'
        fi

        nixos-rebuild switch "${flags[@]}" --flake "$flake"
        ;;
    (b | boot)
        shift

        if (( $# > 0 )); then
            error 'too many arguments'
        fi

        nixos-rebuild boot "${flags[@]}" --flake "$flake"
        ;;
    (*)
        error 'invalid subcommand'
        ;;
esac
