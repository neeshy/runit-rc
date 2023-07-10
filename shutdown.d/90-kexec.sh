# test -x returns false on a noexec mount, hence using find to detect x bit
if [ -n "$(find /run/runit/reboot -perm -u+x 2>/dev/null)" ] && cmd kexec; then
    msg "Triggering kexec..."
    kexec -e 2>/dev/null
    # not reached when kexec was successful.
fi
