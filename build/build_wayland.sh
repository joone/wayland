#!/bin/sh
#
# Wayland Build Script
#
# This script is minimally tested. Your bugfixes/contributions are very
# welcome!!
#
# Gwan-gyeong Moon
# Joone Hur
#

set -x
WLD=$HOME/WaylandBuild/rel
SRC=$HOME/WaylandBuild/src
LD_LIBRARY_PATH=$WLD/lib
PKG_CONFIG_PATH=$WLD/lib/pkgconfig/:$WLD/share/pkgconfig/
ACLOCAL="aclocal -I $WLD/share/aclocal"

export WLD LD_LIBRARY_PATH PKG_CONFIG_PATH
# disable aclocal for autoconf wayland git
#export WLD LD_LIBRARY_PATH PKG_CONFIG_PATH
export XDG_RUNTIME_DIR=/tmp/
export MAKE_COMMAND="make -j4"
###########################################################

###########################################################
sudo rm -rf $WLD
mkdir $WLD
mkdir $WLD/lib
mkdir $WLD/lib/pkgconfig
mkdir $WLD/share/
mkdir $WLD/share/pkgconfig
mkdir $WLD/share/aclocal
###########################################################

###########################################################
cd $SRC
echo "wayland lib pull & build"
cd wayland
git clean -dfx
git reset --hard
git pull
./autogen.sh --prefix=$WLD
make
sudo make install
cd ..
###########################################################

#echo "dri3proto pull & build"
#cd dri3proto
#git clean -dfx
#git reset --hard
#git pull
#./autogen.sh --prefix=$WLD
#make
#sudo make install
#cd ..
###########################################################
export ACLOCAL 
echo "Mesa pull & build"
cd drm
git clean -dfx
git reset --hard
git pull
./autogen.sh --prefix=$WLD
make
sudo make install
cd ..
cd mesa
git clean -dfx
git reset --hard
git pull
./autogen.sh --prefix=$WLD --enable-gles2 --disable-gallium-egl --with-egl-platforms=x11,wayland,drm --enable-gbm --enable-shared-glapi --with-gallium-drivers=r300,r600,swrast,nouveau
make
sudo make install
cd ..
###########################################################

###########################################################
echo "libxkbcommon pull & build"
cd libxkbcommon/
git clean -dfx
git reset --hard
git pull
./autogen.sh --prefix=$WLD --with-xkb-config-root=/usr/share/X11/xkb
make
sudo make install
cd ..
###########################################################

###########################################################
echo "cairo-gl pull & build"
cd pixman
git clean -dfx
git reset --hard
git pull
./autogen.sh --prefix=$WLD
make
sudo make install
cd ..
cd cairo
git clean -dfx
git reset --hard
git pull
./autogen.sh --prefix=$WLD --enable-gl --enable-xcb
make
sudo make install
cd ..
###########################################################

###########################################################
echo "libunwind pull & build"
cd libunwind
git clean -dfx
git reset --hard
git pull
autoreconf -i
./configure --prefix=$WLD
make
sudo make install
cd ..
###########################################################

###########################################################
echo "colord clon & build"
cd colord
git clean -dfx
git reset --hard
git checkout master
git pull
git checkout COLORD_0_1_27
./autogen.sh --prefix=$WLD --disable-static --disable-gtk-doc --disable-gusb --disable-vala
make
sudo make install
cd ..
###########################################################

###########################################################
echo "weston pull & build"
cd weston
git clean -dfx
git reset --hard
git pull
#./autogen.sh --prefix=$WLD --disable-colord
./autogen.sh --prefix=$WLD 
make
sudo make install
cd ..
###########################################################

#mkdir /tmp/wayland
#chmod 0700 /tmp/wayland
