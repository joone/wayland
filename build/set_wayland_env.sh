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

export WLD LD_LIBRARY_PATH PKG_CONFIG_PATH ACLOCAL
# disable aclocal for autoconf wayland git
#export WLD LD_LIBRARY_PATH PKG_CONFIG_PATH
export XDG_RUNTIME_DIR=/tmp/
export MAKE_COMMAND="make -j4"
ulimit -c unlimited
