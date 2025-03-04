if cmd sysctl; then
    msg 'Loading sysctl(8) settings...'
    sysctl --system
fi
