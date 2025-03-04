if [ -x /run/runit/reboot ] && cmd kexec; then
    msg 'Triggering kexec...'
    kexec -e 2>/dev/null
    # not reached when kexec was successful.
fi
