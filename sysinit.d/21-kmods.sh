# Do not try to load modules if kernel does not support them.
if [ -e /proc/modules ]; then
    msg "Loading kernel modules..."
    for f in /etc/modules-load.d/*.conf /usr/lib/modules-load.d/*.conf; do
        [ -e "$f" ] || continue
        grep -v -e '^#' -e '^$' "$f" | PATH="$PATH" xargs -r modprobe -abv |
            sed -E 's:^.*/:\t:g; s:\.ko(\.gz)? $::g'
    done
fi
