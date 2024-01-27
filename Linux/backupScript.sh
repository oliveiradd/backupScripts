#!/bin/bash

## file with list of directories to backup
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")
dir_list=$script_dir/targets

## remote parameters
remote_user=$USER
server=10.8.0.1

## local partitions
backup_partitions=(
DBackup0
DBackup1
DBackup2
)

devices_mount_path=/run/media/$USER
samba_mount_point=/run/user/$UID/gvfs/smb-share:server=$server,share=$remote_user
openvpn_filename=thinkpad-noredir
target=$1
action=$2
mode=$3
additional_option=$4

#rsync_options="-rtuv --no-links"
#rsync_options="-auv"
rsync_options="-rltgoDuv"

## backup function
backup_data() {
	if [[ $2 = --sync ]]; then
		mode2=--delete-delay
	elif [[ $2 = --add ]]; then
		true
	else
		echo "Segundo argumento não reconhecido"
		exit 1
	fi

	if [[ $1 = --send ]]; then
		rsync --mkpath $rsync_options --exclude={'.*','Downloads','Public','Templates'} $mode2 $3 $path/ $external_storage$path/
	elif [[ $1 = --receive ]]; then
		rsync --mkpath $rsync_options --exclude={'.*','Downloads','Public','Templates'} --force $mode2 $3 $external_storage$path/ $path
	else
		echo "Primeiro argumento não reconhecido."
		exit 1
	fi
}

## snapshot function
snapshot() {
	if (mount | grep $partition_name | grep -q btrfs) then
		notify-send --icon=emblem-synchronizing "Backup complete." "Enter password to create read-only snapshot."
		sudo btrfs subvolume snapshot -r $external_storage "$external_storage - $(date +%Y-%m-%d\ %T)"
	else
		notify-send --icon=emblem-synchronizing "Backup complete." "You may close the terminal."
		echo "$partition_name não é BTRFS. Snapshot não será criado."
	fi
}

## local transfer function
local_transfer() {
for partition_name in ${backup_partitions[@]}; do
	external_storage=$devices_mount_path/$partition_name/$HOSTNAME
	if [[ -d $external_storage ]]; then
		backup_data $action $mode $additional_option
        break
	fi
done
}

## vpn function
vpn() {
if [[ $1 = --disconnect ]]; then
	sudo systemctl stop openvpn-client@$openvpn_filename.service
else
	sudo systemctl start openvpn-client@$openvpn_filename.service
fi
}

## samba transfer function
samba_transfer() {
gio mount smb://$server/$remote_user
external_storage=$samba_mount_point
if [[ -d $external_storage ]]; then
	backup_data $action $mode $additional_option
	gio mount --unmount smb://$server/$remote_user
fi
}

## rsync daemon transfer function 
rsync_transfer() {
	external_storage=$remote_user@$server::danielbkp
	backup_data $action $mode $additional_option
}

## Start of script
while IFS= read -r path; do
    if [[ $target = --local ]]; then
        local_transfer
    elif [[ $target = --samba ]]; then
        samba_transfer
    elif [[ $target = --rsyncd ]]; then
    #	vpn
    #	sleep 10
        rsync_transfer
    #	vpn --disconnect
    else 
        echo "Error: invalid target value"
    fi
done < $dir_list

if [[ $additional_option != "--dry-run" && $target == "--local" ]]; then
    snapshot
fi
## End of script

# rsync a/ /b # copia os conteúdos de dentro de a para dentro de b (copia a para / com o nome b)
# rsync a /b # copia a para dentro de b, como /b/a
# rsync a/* /b equivale a rsync a /b

