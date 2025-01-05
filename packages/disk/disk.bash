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

args=$(getopt --options r:m:b:l:c: --longoptions=root:,mapping:,boot-label:,main-label:,cryptmain-label: --name "$progname" -- "$@")

eval set -- "$args"

root=/mnt
mapping=main
bootlbl=BOOT
mainlbl=main
cryptmainlbl=cryptmain
while true; do
  case "$1" in
  (-r | --root)
    root=$2
    shift 2
    ;;
  (-m | --mapping)
    mapping=$2
    shift 2
    ;;
  (-b | --boot-label)
    bootlbl=${2^^}
    shift 2
    ;;
  (-l | --main-label)
    mainlbl=$2
    shift 2
    ;;
  (-c | --cryptmain-label)
    cryptmainlbl=$2
    shift 2
    ;;
  (--)
    shift
    break
    ;;
  esac
done

if (( $# < 1 )); then
  error 'an argument specifying the block device is required'
fi

if (( $# > 1 )); then
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

mkfs.vfat -F 32 -n "$bootlbl" -- "$bootfs" >/dev/null

while true; do
  read -r -p 'Do you want your main partition to be encrypted [y/N]? ' luks
  case "$luks" in
  ([Yy]*)
    while true; do
      read -r -s -p 'Enter password: ' password
      warn ''
      read -r -s -p 'Re-enter password: ' repassword
      warn ''
      if [[ $password == "$repassword" ]]; then
        break
      fi
    done

    cryptsetup luksFormat --batch-mode --label "$cryptmainlbl" "$mainblkdev" <<<"$password"
    cryptsetup open "$mainblkdev" "$mapping" <<<"$password"

    mainfs=/dev/mapper/$mapping
    break
    ;;
  ('' | [Nn]*)
    mainfs=$mainblkdev
    break
    ;;
  (*) warn 'Please answer with yes or no' ;;
  esac
done

mkfs.ext4 -q -F -L "$mainlbl" -- "$mainfs"
mkdir --parents -- "$root"
mount --options noatime -- "$mainfs" "$root"

mkdir -- "$root/boot"
mount -- "$bootfs" "$root/boot"
