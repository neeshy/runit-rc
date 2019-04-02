msg "Mounting pseudo-filesystems..."
mnt nosuid,noexec,nodev proc proc /proc
mnt nosuid,noexec,nodev sysfs sys /sys
mnt nosuid,mode=0755 devtmpfs dev /dev
mnt nosuid,nodev,mode=0755 tmpfs run /run
mkdir -p /run/lock /dev/pts /dev/shm
mnt nosuid,noexec,mode=0620 devpts devpts /dev/pts
mnt nosuid,nodev,mode=1777 tmpfs shm /dev/shm
mnt nosuid,noexec,nodev securityfs securityfs /sys/kernel/security
mnt nosuid,noexec,nodev debugfs debugfs /sys/kernel/debug
mnt nosuid,noexec,nodev tracefs tracefs /sys/kernel/tracing
mnt nosuid,noexec,nodev configfs configfs /sys/kernel/config

ln -sfn /proc/self/fd /dev/fd
ln -sfn /proc/self/fd/0 /dev/stdin
ln -sfn /proc/self/fd/1 /dev/stdout
ln -sfn /proc/self/fd/2 /dev/stderr

[ -d /sys/firmware/efi/efivars ] && mnt nosuid,noexec,nodev efivars efivars /sys/firmware/efi/efivars

# cgroup v1
mnt nosuid,noexec,nodev,mode=0755 tmpfs cgroup /sys/fs/cgroup
while read -r name _ _ enabled; do
    [ "$enabled" = 1 ] || continue
    controller="/sys/fs/cgroup/$name"
    mkdir -p "$controller"
    mnt "nosuid,noexec,nodev,$name" cgroup "$name" "$controller"
done </proc/cgroups

# cgroup v2
mkdir -p /sys/fs/cgroup/unified
mnt nosuid,noexec,nodev,nsdelegate cgroup2 cgroup2 /sys/fs/cgroup/unified
