msg 'Unmounting filesystems, disabling swap...'
swapoff -a
umount -ar -t noproc,nosysfs,nodevtmpfs,notmpfs
msg 'Remounting rootfs read-only...'
mount -o remount,ro /

sync

if cmd zpool zfs; then
    msg 'Unsharing ZFS file systems...'
    zfs unshare -a

    msg 'Unmounting ZFS file systems...'
    zfs unmount -au

    msg 'Exporting ZFS pools...'
    zpool export -a
fi

deactivate_vgs() {
    group="${1:-All}"
    if cmd vgchange; then
        vgs="$(vgs | wc -l)"
        if [ "$vgs" -gt 0 ]; then
            msg "Deactivating $group LVM Volume Groups..."
            vgchange -an
        fi
    fi
}

deactivate_vgs
if cmd cryptsetup dmsetup; then
    msg 'Deactivating Crypt Volumes'
    for v in $(dmsetup ls --target crypt --exec='dmsetup info -c --noheadings -o open,name'); do
        if [ "${v%%:*}" = 0 ]; then
            v="${v##*:}"
            cryptsetup close "$v" && msg "[crypt] successfully closed: $v"
        fi
    done
    deactivate_vgs 'Crypt'
fi

if cmd mdadm; then
    msg 'Dectivating software RAID arrays...'
    mdadm -Ss
fi
