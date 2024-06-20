# install gcc for arm
# apt install gcc-aarch64-linux-gnu -y

#git clone https://github.com/DPDK/dpdk.git
# Get specific version
VERSION=23.11
wget https://static.dpdk.org/rel/dpdk-$VERSION.tar.xz
# Note, don't clone old version and build directly, because it will cause some build errors
tar xvf dpdk-$VERSION.tar.xz
mv dpdk-$VERSION dpdk_arm64
cd dpdk_arm64

# configure arm gcc path for meson
meson -Dexamples=all build --cross-file config/arm/arm64_armv8_linux_gcc

# build
ninja -C build
file ./build/app/dpdk-test

# reference
https://doc.dpdk.org/guides/linux_gsg/cross_build_dpdk_for_arm64.html
