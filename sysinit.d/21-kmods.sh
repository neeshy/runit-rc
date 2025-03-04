# Do not try to load modules if kernel does not support them.
if [ -e /proc/modules ]; then
    msg 'Loading kernel modules...'
    for f in /etc/modules-load.d/*.conf /usr/lib/modules-load.d/*.conf; do
        [ -r "$f" ] || continue
        for mod in $(sed -E 's/[[:space:]]*(#.*)?$//;s/^[[:space:]]*//;/^$/d' -- "$f"); do
            modprobe -bv -- "$mod" | sed -E 's:^.*/:\t:g;s:\.ko(\.gz)? $::g'
        done
    done
fi
