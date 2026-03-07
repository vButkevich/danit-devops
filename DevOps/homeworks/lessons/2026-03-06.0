2026-03-06
Today

Dmytro Vasiliev 19:22
в чому різниця між while [ 1 ] і while [ true ]

dl 19:31
в чому різниця між while [ 1 ] і while [ true ]
True іінтерпретується в 1 пізніше) Ні в чому)

maksym 19:34
for i in 1 2 3; do
  for j in a b c; do
    if [[ "$j" == "b" ]]; then
      continue 2   # пропустить оставшееся в inner и перейти к следующему i
    fi
    echo "i=$i j=$j"
  done
done
В Bash “continue with tag” есть, но называется это не тэг, а уровень (n): continue N.

Dmytro Vasiliev 19:38
роздільник пробіл 
стовпчик 3

Dmytro Vasiliev 19:39
awk -F';' '{print $7}'

Максим 19:40
awk '{print $3}' file.txt

Yurii Vilchynskyi 19:41
uname -a | awk -F' ' '{print $2}'

Volodymyr Vystavkin 19:42
yes
we need disable set -euo

Dmytro Vasiliev 19:45
-eq рівність чисел
= рівність рядків

Volodymyr Vystavkin 19:48
we can live set -u

Максим 20:09
file

Максим 20:09
>FILE
Messages addressed to "meeting group chat" will also appear in the meeting group chat in Team Chat

Максим 20:34
yes | sudo mkfs.ext4 /dev/sdXN

maksym 20:48
blkid /dev/sdb | sed -n 's/.*UUID="\([^"]*\)".*/\1/p'

maksym 20:48 (Edited)
Можно копирнуть просто команду

Ольга Кирилюк 20:51
#!/bin/bash

# 1. create virtual disk
# 2. lsblk
# 3. input - disk name from lsblk
# 4. check if any file system does not exist.
# 5. if file system exists -> 7.
# 6. if not -> format disk with fs.
# 7.  mount file system to the the folder
# 8. add disk to fstab

set -e

DISK_NAME=$1
MOUNT_POINT="/mnt/mount_disk_task"
FS_TYPE="ext4"

if [[ ! $EUID -eq 0 ]]; then
   echo "Not running as root"
   exit 1
fi

if [[ -z $DISK_NAME ]]; then
    echo "Please provide the disk name as a command-line argument. Usage: $0 <disk_name>."
    exit 1
fi

set +e

ls "$DISK_NAME" &> /dev/null
IS_DISK_EXIST=$?

if [[ $IS_DISK_EXIST -eq 0 ]]; then
    echo "Disk name found: $DISK_NAME"
else
    echo "Disk name not found: $DISK_NAME"
    exit 1
fi

blkid $DISK_NAME | grep $FS_TYPE
IS_EXT4=$?

set -e
if [[ $IS_EXT4 -eq 0 ]]; then
    echo "Disk $DISK_NAME is formatted with $FS_TYPE. Skipping filesystem creation."
else
    echo -e "Disk $DISK_NAME is not formatted with $FS_TYPE.\nCreating filesystem $FS_TYPE on $DISK_NAME."
    # installing ext4
    yes | mkfs.ext4 $DISK_NAME
    echo "Filesystem has been successfully created."
fi

# create mounting point
echo "Creating empty mount point, if not created: $MOUNT_POINT"
mkdir -p $MOUNT_POINT

echo "Mounting disk $DISK_NAME to mount point $MOUNT_POINT..."
mount $DISK_NAME $MOUNT_POINT
echo "Disk $DISK_NAME has been mounted successfully to $MOUNT_POINT."

echo "Processing fstab..."
echo "$DISK_NAME $MOUNT_POINT $FS_TYPE defaults 0 2" >> /etc/fstab
echo "fstab has been processed"