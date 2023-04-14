## Runit init scripts

This repository contains runit init scripts.

This project is based on https://github.com/void-linux/void-runit, which in turn
is loosely based on https://github.com/chneukirchen/ignite

## Dependencies

- A POSIX shell
- grep
- sed
- findutils
- procps-ng (needs pkill -s0,1)
- kmod
- util-linux (needs wall)
- iproute2
- runit
- seedrng (https://git.zx2c4.com/seedrng/about/)

### How to use it

To see enabled services for "current" runlevel:

    $ ls -l /var/service/

To see available runlevels (default and single, which just runs sulogin):

    $ ls -l /etc/runit/runsvdir

To enable and start a service into the "current" runlevel:

    # ln -s /etc/sv/<service> /var/service

To disable and remove a service:

    # rm -f /var/service/<service>

To view status of all services for "current" runlevel:

    # sv status /var/service/*
    
## Copyright

This project is in the public domain.

To the extent possible under law, the creator of this work has waived
all copyright and related or neighboring rights to this work.

http://creativecommons.org/publicdomain/zero/1.0/
