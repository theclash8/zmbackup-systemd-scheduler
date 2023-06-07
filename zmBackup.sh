#!/bin/bash

# Set Zimbra user
ZIMBRA="zimbra"
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

echo "$(date +%D) - Starting Backup"
echo "Mounting remote partition"
${MOUNT_COMMAND} || RET=1
echo "Rotating old backups"
su ${ZIMBRA} -c "${BACKUP_ROTATION}" || RET=1
echo "Backup Aliases"
su ${ZIMBRA} -c "${ALIAS_BACKUP}" || RET=1
echo "Backup Distribution lists"
su ${ZIMBRA} -c "${DISTRIBUTION_LIST_BACKUP}" || RET=1


case ${TODAY} in
  [1-6])
    echo "Performing incremental backup"
    su ${ZIMBRA} -c "${INCREMENTAL_COMMAND}" || RET=1
  ;;
  "7")
    echo "Performing full backup"
    su ${ZIMBRA} -c "${FULL_COMMAND}" || RET=1
  ;;
esac

echo "Unmounting remote partition"
${UMOUNT_COMMAND} || RET=1

if [ ${RET} == 1 ]; then
  echo "The backup process entered an exception. Please refer to the log"
  exit 255
else
  echo "Done"
  exit 0
fi
