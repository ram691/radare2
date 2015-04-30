#!/bin/sh

MAKE=make
gmake --help >/dev/null 2>&1
[ $? = 0 ] && MAKE=gmake

[ -z "${INSTALL_TARGET}" ] && INSTALL_TARGET=symstall

# find root
cd `dirname $PWD/$0` ; cd ..

# update
if [ "$1" != "--without-pull" ]; then
	if [ -d .git ]; then
		git branch | grep "^\* master" > /dev/null
		if [ $? = 0 ]; then
			echo "WARNING: Updating from remote repository"
			git pull
		fi
	fi
else
	shift
fi

[ "`id -u`" = 0 ] || SUDO=sudo
[ -n "${NOSUDO}" ] && SUDO=

if [ "${HARDEN}" = 1 ]; then
	./sys/build-harden.sh $* && ${SUDO} ${MAKE} ${INSTALL_TARGET}
else
	./sys/build.sh $* && ${SUDO} ${MAKE} ${INSTALL_TARGET}
fi
