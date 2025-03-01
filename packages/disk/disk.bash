#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

progname="$0"

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

skip() {
    if (($# < 1)); then
        error 'name of value to be skipped is required'
    fi

    if (($# > 1)); then
        error 'too many arguments'
    fi

    local skip=$1

    for s in "${skips[@]}"; do
        if [[ $s == "$skip" ]]; then
            return 1
        fi
    done

    return 0
}

args=$(
    getopt \
        --options r:b:l:c:m:B:M:v \
        --longoptions root:,boot-label:,main-label:,cryptmain-label:,mapping:,boot-options:,main-options:,verbose \
        --name "$progname" \
        -- "$@"
)

eval set -- "$args"

root=/mnt
bootlbl=BOOT
mainlbl=main
cryptmainlbl=cryptmain
mapping=main
bootflags=
mainflags=
fatflags=()
ext4flags=()
skips=()
while true; do
    case "$1" in
    -r | --root)
        root=$2
        shift 2
        ;;
    -b | --boot-label)
        skips+=(bootlbl)
        bootlbl=${2^^}
        shift 2
        ;;
    -l | --main-label)
        skips+=(mainlbl)
        mainlbl=$2
        shift 2
        ;;
    -c | --cryptmain-label)
        skips+=(cryptmainlbl)
        cryptmainlbl=$2
        shift 2
        ;;
    -m | --mapping)
        skips+=(mapping)
        mapping=$2
        shift 2
        ;;
    -B | --boot-options)
        bootflags+=(--options "$2")
        shift 2
        ;;
    -M | --main-options)
        mainflags+=(--options "$2")
        shift 2
        ;;
    -v | --verbose)
        fatflags+=(-v)
        ext4flags+=(-v)
        shift
        ;;
    --)
        shift
        break
        ;;
    esac
done

if (($# < 1)); then
    error 'an argument specifying the block device is required'
fi

if (($# > 1)); then
    error 'too many arguments'
fi

blkdev=$1

sfdisk --label gpt --quiet -- "$blkdev" <<EOF
,512M,U;
,,L;
EOF

parts=()
json=$(sfdisk --json -- "$blkdev")
while IFS= read -r k; do
    parts+=("$(jq --argjson k "$k" --raw-output '.partitiontable.partitions[$k].node' <<<"$json")")
done < <(jq '.partitiontable.partitions | keys[]' <<<"$json")

bootfs="${parts[0]}"
mainblkdev="${parts[1]}"

if ! skip bootlbl; then
    read -rep "Which label should the boot file system have? [$bootlbl] " input
    if [[ -n $input ]]; then
        bootlbl=$input
    fi
fi

mkfs.fat -F 32 -n "$bootlbl" "${fatflags[@]}" -- "$bootfs" >/dev/null

while true; do
    read -rep 'Do you want your main partition to be encrypted? [y/N] ' input
    case "$input" in
    [Yy]*)
        while true; do
            read -rsp 'Enter password: ' password
            warn ''
            read -rsp 'Re-enter password: ' repassword
            warn ''
            if [[ $password == "$repassword" ]]; then
                break
            fi
        done

        if ! skip cryptmainlbl; then
            read -rep "Which label should the main LUKS partition have? [$cryptmainlbl] " input
            if [[ -n $input ]]; then
                cryptmainlbl=$input
            fi
        fi

        cryptsetup luksFormat --batch-mode --label "$cryptmainlbl" -- "$mainblkdev" <<<"$password"

        if ! skip mapping; then
            read -rep "Which name should the main LUKS mapping have? [$mapping] " input
            if [[ -n $input ]]; then
                mapping=$input
            fi
        fi

        cryptsetup open -- "$mainblkdev" "$mapping" <<<"$password"

        mainfs=/dev/mapper/$mapping
        break
        ;;
    '' | [Nn]*)
        mainfs=$mainblkdev
        break
        ;;
    *) warn 'Please answer with yes or no' ;;
    esac
done

if ! skip mainlbl; then
    read -rep "Which label should the main file system have? [$mainlbl] " input
    if [[ -n $input ]]; then
        mainlbl=$input
    fi
fi

mkfs.ext4 -qFL "$mainlbl" "${ext4flags[@]}" -- "$mainfs"
mkdir --parents -- "$root"
mount "${mainflags[@]}" -- "$mainfs" "$root"

mkdir -- "$root/boot"
mount "${bootflags[@]}" -- "$bootfs" "$root/boot"
