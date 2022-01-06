{ pkgs, writeShellScriptBin }:

writeShellScriptBin "disk-mapper-part" ''
  set -x
  DISK=$1
  DM_NAME=$(basename $DISK)
  if [[ ! -e /dev/mapper/$DM_NAME ]]; then
  DISK_ID=''${2-$(printf %s "$DM_NAME" | sha256sum)}
  DISK_TYPE=7 # NTFS
  MBR_FILE=$(mktemp -t vm-$DM_NAME-XXXXXXXX.mbr)
  BLOCK=$(basename $(readlink $DISK))
  BLOCK_START=$(cat /sys/class/block/$BLOCK/start)
  BLOCK_SIZE=$(cat /sys/class/block/$BLOCK/size)
  DISK_SIZE=$(((BLOCK_SIZE + 2048 + 2047) / 2048 * 2048))
  dd if=/dev/zero of=$MBR_FILE bs=512 count=2048 status=none

  LDEV=$(losetup --show -f $MBR_FILE)
  END_GUARD=$((DISK_SIZE - 2048 - BLOCK_SIZE))
  if [[ $END_GUARD -ne 0 ]]; then
    END_GUARD="$((BLOCK_SIZE + 2048)) $END_GUARD zero"
  else
    END_GUARD=
  fi
  dmsetup create $DM_NAME <<EOF
  0 2048 linear $LDEV 0
  2048 $BLOCK_SIZE linear $DISK 0
  $END_GUARD
  EOF
  CYL=$((DISK_SIZE / 2048))
  if [[ $CYL -gt 65535 ]]; then
  CYL=65535
  fi
  dmsetup setgeometry $DM_NAME $CYL 64 32 0
  chown "$USER" /dev/mapper/$DM_NAME
  sfdisk --quiet --no-tell-kernel --no-reread /dev/mapper/$DM_NAME <<EOF
  label: dos
  label-id: 0x''${DISK_ID:8}
  device: $DM_NAME
  unit: sectors
  grain: 512
  sector-size: 512

  1 : start=2048, size=$BLOCK_SIZE, type=$DISK_TYPE
  EOF
  fi
''
