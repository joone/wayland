#!/bin/sh
#
# Running Environment Setting Script
#
# This script is minimally tested. Your bugfixes/contributions are very
# welcome!!
#
# Gwan-gyeong Moon
# Joone Hur
#

WLD=$HOME/WaylandBuild/rel
LD_LIBRARY_PATH=$WLD/lib
PKG_CONFIG_PATH=$WLD/lib/pkgconfig/:$WLD/share/pkgconfig/
ACLOCAL="aclocal -I $WLD/share/aclocal"
export PATH=$PATH:$WLD/bin
export GYP_DEFINES="component=static_library use_ash=0 use_aura=1 chromeos=0 use_ozone=1 remove_webcore_debug_symbols=1"

export WLD LD_LIBRARY_PATH PKG_CONFIG_PATH ACLOCAL
# disable aclocal for autoconf wayland git
#export WLD LD_LIBRARY_PATH PKG_CONFIG_PATH
#export XDG_RUNTIME_DIR=/tmp/

if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi

export MAKE_COMMAND="make -j4"
ulimit -c unlimited
