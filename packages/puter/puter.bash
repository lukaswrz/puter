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

args=$(
    getopt \
        --options F:f:o:t:v \
        --longoptions flakeref:,flake:,on:,to:,verbose \
        --name "$progname" \
        -- "$@"
)

eval set -- "$args"

if [[ -v PUTER_FLAKEREF && -n $PUTER_FLAKEREF ]]; then
    flakeref=$PUTER_FLAKEREF
fi
flags=(
    --refresh
    --use-remote-sudo
    --no-write-lock-file
)
verbose=false
while true; do
    case $1 in
    -F | --flakeref)
        flakeref=$2
        shift 2
        ;;
    -f | --flake)
        flake=$2
        shift 2
        ;;
    -o | --on)
        flags+=(--build-host "$2")
        shift 2
        ;;
    -t | --to)
        host=$2
        flags+=(--target-host "$host")
        shift 2
        ;;
    -v | --verbose)
        flags+=(--verbose)
        verbose=true
        shift
        ;;
    --)
        shift
        break
        ;;
    esac
done

if [[ ! -v flake ]]; then
    if [[ -v flakeref ]]; then
        warn "using flake reference $flakeref"
        if [[ -v host ]]; then
            hostname=$(ssh -- "$host" hostname)
        else
            hostname=$(hostname)
        fi
        if [[ -z $hostname ]]; then
            error 'hostname could not be resolved and no flake specified'
        fi
        flake=$flakeref#$hostname
        warn "resolved to $flake"
    else
        error 'no flake or flake reference specified'
    fi
fi

flags+=(--flake "$flake")

if (($# == 0)); then
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
s | switch)
    shift

    if (($# > 0)); then
        error 'too many arguments'
    fi

    run switch
    ;;
b | boot)
    shift

    if (($# > 0)); then
        error 'too many arguments'
    fi

    run boot
    ;;
t | test)
    shift

    if (($# > 0)); then
        error 'too many arguments'
    fi

    run test
    ;;
bld | build)
    shift

    if (($# > 0)); then
        error 'too many arguments'
    fi

    run build
    ;;
dbld | dry-build)
    shift

    if (($# > 0)); then
        error 'too many arguments'
    fi

    run dry-build
    ;;
da | dry-activate)
    shift

    if (($# > 0)); then
        error 'too many arguments'
    fi

    run dry-activate
    ;;
vm | build-vm)
    shift

    if (($# > 0)); then
        error 'too many arguments'
    fi

    run build-vm
    ;;
i | img | build-image)
    shift

    if (($# < 1)); then
        error 'image variant is required'
    fi

    if (($# > 1)); then
        error 'too many arguments'
    fi

    variant=$1

    flags+=("$variant")

    run build-image
    ;;
*)
    error 'invalid subcommand'
    ;;
esac
