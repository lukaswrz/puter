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

skips=()

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
      return 0
    fi
  done

  return 1
}

args=$(
  getopt \
    --options v \
    --longoptions mount:,create-boot,label:,boot-label:,crypt-label:,mapping:,mount-options:,boot-mount-options:,verbose \
    --name "$progname" \
    -- "$@"
)

eval set -- "$args"

mount=/mnt
mkboot=0
bootlbl=BOOT
lbl=main
cryptlbl=cryptmain
mapping=main
bootmntflags=()
mntflags=()
fatflags=()
ext4flags=()
while true; do
  case "$1" in
  --mount)
    mount=$2
    shift 2
    ;;
  --create-boot)
    skips+=(mkboot)
    mkboot=1
    shift
    ;;
  --label)
    skips+=(lbl)
    lbl=$2
    shift 2
    ;;
  --boot-label)
    skips+=(bootlbl)
    bootlbl=${2^^}
    shift 2
    ;;
  --crypt-label)
    skips+=(cryptlbl)
    cryptlbl=$2
    shift 2
    ;;
  --mapping)
    skips+=(mapping)
    mapping=$2
    shift 2
    ;;
  --mount-options)
    mntflags+=(--options "$2")
    shift 2
    ;;
  --boot-mount-options)
    bootmntflags+=(--options "$2")
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

if ! skip mkboot; then
  while true; do
    read -rep 'Do you want to create a boot partition? [y/N] ' input
    case "$input" in
    [Yy]*)
      mkboot=1
      break
      ;;
    '' | [Nn]*)
      mkboot=0
      break
      ;;
    *) warn 'Please answer with yes or no' ;;
    esac
  done
fi

{
  if ((mkboot)); then
    echo ',512M,U;'
  fi
  echo ',,L;'
} | sfdisk --label gpt --quiet -- "$blkdev"

parts=()
json=$(sfdisk --json -- "$blkdev")
while IFS= read -r k; do
  parts+=("$(jq --argjson k "$k" --raw-output '.partitiontable.partitions[$k].node' <<<"$json")")
done < <(jq '.partitiontable.partitions | keys[]' <<<"$json")

if ((!mkboot)); then
  blkdev="${parts[0]}"
else
  bootfs="${parts[0]}"
  blkdev="${parts[1]}"

  if ! skip bootlbl; then
    read -rep "Which label should the boot file system have? [$bootlbl] " input
    if [[ -n $input ]]; then
      bootlbl=$input
    fi
  fi

  mkfs.fat -F 32 -n "$bootlbl" "${fatflags[@]}" -- "$bootfs" >/dev/null
fi

while true; do
  read -rep 'Do you want this disk to be encrypted? [y/N] ' input
  case "$input" in
  [Yy]*)
    while true; do
      read -rsp 'Enter password: ' password
      echo >&2
      read -rsp 'Re-enter password: ' repassword
      echo >&2
      if [[ $password == "$repassword" ]]; then
        break
      fi
    done

    if ! skip cryptlbl; then
      read -rep "Which label should the LUKS partition have? [$cryptlbl] " input
      if [[ -n $input ]]; then
        cryptlbl=$input
      fi
    fi

    cryptsetup luksFormat --batch-mode --label "$cryptlbl" -- "$blkdev" <<<"$password"

    if ! skip mapping; then
      read -rep "Which name should the LUKS mapping have? [$mapping] " input
      if [[ -n $input ]]; then
        mapping=$input
      fi
    fi

    cryptsetup open -- "$blkdev" "$mapping" <<<"$password"

    fs=/dev/mapper/$mapping
    break
    ;;
  '' | [Nn]*)
    fs=$blkdev
    break
    ;;
  *) warn 'Please answer with yes or no' ;;
  esac
done

if ! skip lbl; then
  read -rep "Which label should the file system have? [$lbl] " input
  if [[ -n $input ]]; then
    lbl=$input
  fi
fi

mkfs.ext4 -qFL "$lbl" "${ext4flags[@]}" -- "$fs"
mkdir --parents -- "$mount"
mount "${mntflags[@]}" -- "$fs" "$mount"

if ((mkboot)); then
  mkdir -- "$mount/boot"
  mount "${bootmntflags[@]}" -- "$bootfs" "$mount/boot"
fi
