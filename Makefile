PREFIX = /usr

install:
	install -Dm755 halt ${DESTDIR}${PREFIX}/sbin/halt
	ln -sf halt ${DESTDIR}${PREFIX}/sbin/poweroff
	install -Dm755 reboot ${DESTDIR}${PREFIX}/sbin/reboot
	install -Dm644 -t ${DESTDIR}/etc/runit/sysinit.d sysinit.d/*.sh
	install -Dm644 -t ${DESTDIR}/etc/runit/shutdown.d shutdown.d/*.sh
	install -Dm755 -t ${DESTDIR}/etc/runit 1 2 3 ctrlaltdel
	install -Dm644 functions ${DESTDIR}/etc/runit/functions
	install -Dm755 -t ${DESTDIR}/etc rc.local rc.shutdown
	ln -sf /run/runit/reboot ${DESTDIR}/etc/runit/reboot
	ln -sf /run/runit/stopit ${DESTDIR}/etc/runit/stopit
	install -Dm755 services/agetty/run ${DESTDIR}/etc/sv/agetty/run
	install -Dm755 services/agetty/finish ${DESTDIR}/etc/sv/agetty/finish
	install -Dm755 services/sulogin/run ${DESTDIR}/etc/sv/sulogin/run
	install -d ${DESTDIR}/etc/runit/runsvdir/default ${DESTDIR}/etc/runit/runsvdir/single ${DESTDIR}/var
	ln -sfn default ${DESTDIR}/etc/runit/runsvdir/current
	ln -sfn /run/runit/runsvdir/current ${DESTDIR}/var/service
	for n in 1 2 3 4 5 6; do \
		install -d ${DESTDIR}/etc/sv/agetty-tty$$n; \
		ln -sfn ../agetty/run ${DESTDIR}/etc/sv/agetty-tty$$n/run; \
		ln -sfn ../agetty/finish ${DESTDIR}/etc/sv/agetty-tty$$n/finish; \
		ln -sfn /etc/sv/agetty-tty$$n ${DESTDIR}/etc/runit/runsvdir/default/agetty-tty$$n; \
	done
	ln -sfn /etc/sv/sulogin ${DESTDIR}/etc/runit/runsvdir/single/sulogin
