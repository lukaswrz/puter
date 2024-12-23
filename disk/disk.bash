#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

opts=$(getopt --options r:m:b:l:c: --longoptions=root:,mapping:,boot-label:,main-label:,cryptmain-label: --name "$0" -- "$@")

eval set -- "$opts"

root=/mnt
mapping=main
bootlbl=BOOT
mainlbl=main
cryptmainlbl=cryptmain
while true; do
  case "$1" in
  -r | --root)
    root=$2
    shift 2
    ;;
  -m | --mapping)
    mapping=$2
    shift 2
    ;;
  -b | --boot-label)
    bootlbl=${2^^}
    shift 2
    ;;
  -l | --main-label)
    mainlbl=$2
    shift 2
    ;;
  -c | --cryptmain-label)
    cryptmainlbl=$2
    shift 2
    ;;
  --)
    shift
    break
    ;;
  esac
done

if [[ $# != 1 ]]; then
  printf '%s\n' "$0: an argument specifying the block device is required" 1>&2
  exit 1
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
      printf '\n'
      read -r -s -p 'Re-enter password: ' repassword
      printf '\n'
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
  (*) printf 'Please answer with yes or no\n' 1>&2 ;;
  esac
done

mkfs.ext4 -q -F -L "$mainlbl" -- "$mainfs"
mkdir --parents -- "$root"
mount --options noatime -- "$mainfs" "$root"

mkdir -- "$root/boot"
mount -- "$bootfs" "$root/boot"
