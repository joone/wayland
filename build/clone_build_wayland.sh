#!/bin/sh
#
# Wayland Build Script
#
# This script is minimally tested. Your bugfixes/contributions are very
# welcome!!
#
# Contributors:
# Gwan-gyeong Moon
# Joone Hur
#

set -x
WLD=$HOME/WaylandBuild/rel
SRC=$HOME/WaylandBuild/src
LD_LIBRARY_PATH=$WLD/lib
PKG_CONFIG_PATH=$WLD/lib/pkgconfig/:$WLD/share/pkgconfig/
ACLOCAL="aclocal -I $WLD/share/aclocal"
PATH=$PATH:$WLD/bin

WAYLANDBRANCH=1.3
MESABRANCH=10.0
WESTONBRANCH=1.3

export WLD LD_LIBRARY_PATH PKG_CONFIG_PATH PATH
# disable aclocal for autoconf wayland git
#export WLD LD_LIBRARY_PATH PKG_CONFIG_PATH
export XDG_RUNTIME_DIR=/tmp/
export MAKE_COMMAND="make -j4"
###########################################################

###########################################################
mkdir $HOME/WaylandBuild
mkdir $SRC
mkdir $WLD
mkdir $WLD/lib
mkdir $WLD/lib/pkgconfig
mkdir $WLD/share/
mkdir $WLD/share/pkgconfig
mkdir $WLD/share/aclocal
###########################################################

###########################################################
cd $SRC
echo "wayland lib clone & build"
git clone git://anongit.freedesktop.org/wayland/wayland
cd wayland
git checkout remotes/origin/$WAYLANDBRANCH -b wayland-$WAYLANDBRANCH
./autogen.sh --prefix=$WLD
make
make install
cd ..

###########################################################
echo "Clone & build glproto"
git clone git://anongit.freedesktop.org/xorg/proto/glproto
cd glproto
./autogen.sh --prefix=$WLD
make
make install
cd ..

###########################################################
echo "dri2proto clone & build"
git clone git://anongit.freedesktop.org/xorg/proto/dri2proto
cd dri2proto
./autogen.sh --prefix=$WLD
make
make install
cd ..
###########################################################
export ACLOCAL 
echo "Mesa clone & build"
git clone git://anongit.freedesktop.org/git/mesa/drm
cd drm
./autogen.sh --prefix=$WLD
make
make install
cd ..
git clone git://anongit.freedesktop.org/mesa/mesa
cd mesa
git checkout remotes/origin/$MESABRANCH -b mesa-$MESABRANCH
./autogen.sh --prefix=$WLD --enable-gles2 --disable-gallium-egl --with-egl-platforms=x11,wayland,drm --enable-gbm --enable-shared-glapi --with-gallium-drivers=r300,r600,swrast,nouveau
make
make install
cd ..

###########################################################
#Libxkbcommon
###########################################################
echo "libxkbcommon clone & build"
git clone git://github.com/xkbcommon/libxkbcommon
cd libxkbcommon/
./autogen.sh --prefix=$WLD --with-xkb-config-root=/usr/share/X11/xkb
make
make install
cd ..

###########################################################
#cairo-gl and pixman
###########################################################
echo "cairo-gl clone & build"
git clone git://anongit.freedesktop.org/pixman
cd pixman
./autogen.sh --prefix=$WLD
make
make install
cd ..
git clone git://anongit.freedesktop.org/cairo
cd cairo
./autogen.sh --prefix=$WLD --enable-gl --enable-xcb
make
make install
cd ..
###########################################################

###########################################################
echo "libunwind clone & build"
git clone git://git.sv.gnu.org/libunwind
cd libunwind
autoreconf -i
./configure --prefix=$WLD
make
make install
cd ..
###########################################################

###########################################################
#echo "colord clone & build"
#git clone git://github.com/hughsie/colord.git
#cd colord 
#git checkout COLORD_0_1_27 -b COLORD_0_1_27
#./autogen.sh --prefix=$WLD --disable-static --disable-gtk-doc --disable-gusb --disable-vala
#make
#make install
#cd ..
###########################################################

###########################################################
echo "weston clone & build"
git clone git://anongit.freedesktop.org/wayland/weston
cd weston
git checkout remotes/origin/$WESTONBRANCH -b weston-$WESTONBRANCH
#./autogen.sh --prefix=$WLD --disable-colord
./autogen.sh --prefix=$WLD
make
make install
cd ..
###########################################################

#mkdir /tmp/wayland
#chmod 0700 /tmp/wayland
