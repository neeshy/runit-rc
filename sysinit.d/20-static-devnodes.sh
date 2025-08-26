# Some kernel modules must be loaded before starting mdevd.
# Load them by looking at the output of `kmod static-nodes`.
if [ -e /proc/modules ]; then
    for f in $(kmod static-nodes -f devname 2>/dev/null | cut -d' ' -f1); do
        modprobe -bq -- "$f" 2>/dev/null
    done
fi
