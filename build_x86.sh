#git clone https://github.com/DPDK/dpdk.git
# Get specific version
VERSION=23.11
wget https://static.dpdk.org/rel/dpdk-$VERSION.tar.xz
# Note, don't clone old version and build directly, because it will cause some build errors
tar xvf dpdk-$VERSION.tar.xz
mv dpdk-$VERSION dpdk_x86
cd dpdk_x86

# Enable -Db_lundef=false -Db_sanitize=address, if need Address Sanitizer check.
#meson -Dbuildtype=debug -Db_lundef=false -Db_sanitize=address -Dexamples=all build
# Enable -Dbuildtype=debug if needed.
#meson -Dbuildtype=debug -Dexamples=all build
meson -Dexamples=all build
cd build

# Or skip this step, simply do ninja install, it will also do build
ninja -j8

# Make dpdk tools visible in system path
sudo ninja install

# Make newly installed library effective in system
sudo ldconfig

# Run some tests if needed
dpdk-test

