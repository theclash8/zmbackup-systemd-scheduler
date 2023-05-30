#!/bin/bash

# Get day of the week
TODAY=$(date +%u)
# Remote partition mounting command
MOUNT_COMMAND=""
# Umount command
UMOUNT_COMMAND=""
# Full backup command
FULL_COMMAND="zmbackup -f"
# Incremental backup command
INCREMENTAL_COMMAND="zmbackup -i"
# Backup Rotation command
BACKUP_ROTATION="zmbackup -hp"
# Distribution list backup command
DISTRIBUTION_LIST_BACKUP="zmbackup -f -dl"
# Alias Backup command
ALIAS_BACKUP="zmbackup -f -al"


RET=0
function runCommand() {
  $@ || RET=1
}

echo $TODAY
echo "$(date +%D) - Starting Backup"
echo "Mounting remote partition"
runCommand "${MOUNT_COMMAND}"
echo "Rotating old backups"
runCommand "${BACKUP_ROTATION}"
echo "Backup Aliases"
runCommand "${ALIAS_BACKUP}"
echo "Backup Distribution lists"
runCommand ${DISTRIBUTION_LIST_BACKUP}


case ${TODAY} in
  [1-6])
    echo "Performing incremental backup"
    runCommand ${INCREMENTAL_COMMAND}
  ;;
  "7")
    echo "Performing full backup"
    runCommand ${FULL_COMMAND}
  ;;
esac

echo "Unmounting remote partition"
runCommand ${UMOUNT_COMMAND}

if [ ${RET} == 1 ]; then
  echo "The backup process entered an exception. Please refer to the log"
  exit 255
else
  echo "Done"
  exit 0
fi
