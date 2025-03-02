msg 'Mounting pseudo-filesystems...'
mnt nosuid,nodev,noexec proc proc /proc
mnt nosuid,nodev,noexec sysfs sys /sys
mnt nosuid,mode=0755 devtmpfs dev /dev
mnt nosuid,nodev,mode=0755 tmpfs run /run
mkdir -p /run/lock /dev/pts /dev/shm /dev/mqueue
mnt nosuid,noexec,mode=0620 devpts devpts /dev/pts
mnt nosuid,nodev,mode=1777 tmpfs shm /dev/shm
mnt nosuid,nodev,noexec,nsdelegate,memory_recursiveprot cgroup2 cgroup2 /sys/fs/cgroup
mnt nosuid,nodev,noexec mqueue mqueue /dev/mqueue
mnt nosuid,nodev,noexec securityfs securityfs /sys/kernel/security
mnt nosuid,nodev,noexec debugfs debugfs /sys/kernel/debug
mnt nosuid,nodev,noexec tracefs tracefs /sys/kernel/tracing
mnt nosuid,nodev,noexec configfs configfs /sys/kernel/config

[ -d /sys/firmware/efi/efivars ] && mnt nosuid,nodev,noexec efivars efivars /sys/firmware/efi/efivars

ln -sfn /proc/self/fd /dev/fd
ln -sfn /proc/self/fd/0 /dev/stdin
ln -sfn /proc/self/fd/1 /dev/stdout
ln -sfn /proc/self/fd/2 /dev/stderr
