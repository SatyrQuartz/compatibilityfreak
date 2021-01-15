arch=$(arch)

git clone https://github.com/ptitSeb/box86
cd box86
mkdir build
cd build

if [ $arch = armv7l ]; then
    cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo
fi

if [ $arch = aarch64 ]; then
    cmake .. -DCMAKE_C_COMPILER=/usr/bin/arm-linux-gnueabihf-gcc -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo
fi

make

checkinstall -y --pkgname=box86 --pkgarch=armhf --fstrans=no

cd ../../