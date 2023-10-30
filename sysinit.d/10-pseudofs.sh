msg "Mounting pseudo-filesystems..."
mnt nosuid,nodev,noexec,noatime proc proc /proc
mnt nosuid,nodev,noexec,noatime sysfs sys /sys
mnt nosuid,noatime,mode=0755 devtmpfs dev /dev
mnt nosuid,nodev,noatime,mode=0755 tmpfs run /run
mkdir -p /run/lock /dev/pts /dev/shm
mnt nosuid,noexec,noatime,mode=0620 devpts devpts /dev/pts
mnt nosuid,nodev,noatime,mode=1777 tmpfs shm /dev/shm
mnt nosuid,nodev,noexec,noatime securityfs securityfs /sys/kernel/security
mnt nosuid,nodev,noexec,noatime debugfs debugfs /sys/kernel/debug
mnt nosuid,nodev,noexec,noatime tracefs tracefs /sys/kernel/tracing
mnt nosuid,nodev,noexec,noatime configfs configfs /sys/kernel/config

ln -sfn /proc/self/fd /dev/fd
ln -sfn /proc/self/fd/0 /dev/stdin
ln -sfn /proc/self/fd/1 /dev/stdout
ln -sfn /proc/self/fd/2 /dev/stderr

[ -d /sys/firmware/efi/efivars ] && mnt nosuid,nodev,noexec,noatime efivars efivars /sys/firmware/efi/efivars

# cgroup v1
mnt nosuid,nodev,noexec,noatime,mode=0755 tmpfs cgroup /sys/fs/cgroup
while read -r name _ _ enabled; do
    [ "$enabled" = 1 ] || continue
    controller="/sys/fs/cgroup/$name"
    mkdir -p "$controller"
    mnt "nosuid,nodev,noexec,noatime,$name" cgroup "$name" "$controller"
done </proc/cgroups

# cgroup v2
mkdir -p /sys/fs/cgroup/unified
mnt nosuid,nodev,noexec,noatime,nsdelegate cgroup2 cgroup2 /sys/fs/cgroup/unified
