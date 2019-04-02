if cmd sysctl; then
    msg "Loading sysctl(8) settings..."
    for f in /usr/lib/sysctl.d/*.conf /etc/sysctl.d/*.conf /etc/sysctl.conf; do
        [ -e "$f" ] && sysctl -p "$f"
    done
fi
