if cmd mdevd mdevd-coldplug; then
    msg 'Starting mdevd and waiting for devices to settle...'
    mdevd -C 2>/dev/null &
    sleep 1
else
    msg_warn 'cannot find mdevd!'
fi
