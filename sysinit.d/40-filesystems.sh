msg 'Remounting rootfs read-only...'
if ! findmnt / -O ro >/dev/null 2>&1; then
    mount -o remount,ro / || emergency_shell
fi

if cmd dmraid; then
    msg 'Activating dmraid devices...'
    dmraid -i -ay
fi

if cmd mdadm; then
    msg 'Activating software RAID arrays...'
    mdadm -As
fi

if cmd btrfs; then
    msg 'Activating btrfs devices...'
    btrfs device scan || emergency_shell
fi

if cmd vgchange; then
    msg 'Activating LVM devices...'
    vgchange --sysinit -a ay || emergency_shell
fi

if cmd zpool zfs; then
    if [ -s /etc/zfs/zpool.cache ]; then
        msg 'Importing cached ZFS pools...'
        zpool import -Na -c /etc/zfs/zpool.cache
    else
        msg 'Scanning for and importing ZFS pools...'
        zpool import -Na
    fi

    msg 'Mounting ZFS file systems...'
    zfs mount -al

    msg 'Sharing ZFS file systems...'
    zfs share -a

    # NOTE(dh): ZFS has ZVOLs, block devices on top of storage pools.
    # In theory, it would be possible to use these as devices in
    # dmraid, btrfs, LVM and so on. In practice it's unlikely that
    # anybody is doing that, so we aren't supporting it for now.
fi

msg 'Checking filesystems...'
fsck -ATaf -t noopts=_netdev
# It can't be assumed that success is 0
# and failure is > 0.
[ "$?" -gt 1 ] && emergency_shell

msg 'Mounting rootfs read-write...'
mount -o remount,rw / || emergency_shell

msg 'Mounting all non-network filesystems...'
mount -a -t nonfs,nonfs4,nosmbfs,nocifs -O no_netdev || emergency_shell
