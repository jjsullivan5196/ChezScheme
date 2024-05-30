# Chez build settings
SCHEME_BIN="scheme.com"
PREFIX=/zip/usr
CONFIG_FLAGS="--prefix=$PREFIX --installabsolute --installschemename=$SCHEME_BIN --disable-x11 --disable-curses"

# cosmocc toolchain
COSMOCC=/opt/cosmocc
export PATH="$COSMOCC/bin:$PATH"

# need to disable zipos so we can use /zip as part of the install
# prefix
export COSMOPOLITAN_DISABLE_ZIPOS=1

# prefix and build dirs
sudo mkdir -p $PREFIX
sudo chown -R "$(id -u):$(id -g)" $PREFIX
mkdir ./dist

# build host amd64 Chez
export CC=$COSMOCC/bin/x86_64-unknown-cosmo-cc
export AR=$COSMOCC/bin/x86_64-unknown-cosmo-ar
./configure ${CONFIG_FLAGS}
make -j
make install
cp $PREFIX/bin/$SCHEME_BIN ./dist/$SCHEME_BIN.ta6le

# cross compile aarch64
export CC=$COSMOCC/bin/aarch64-unknown-cosmo-cc
export AR=$COSMOCC/bin/aarch64-unknown-cosmo-ar
./configure -m=tarm64le ${CONFIG_FLAGS}
make -j
make install
cp $PREFIX/bin/$SCHEME_BIN ./dist/$SCHEME_BIN.tarm64le

# copy results and dump unnecessary files
cp -r $PREFIX ./dist/
rm -rf ./dist/usr/bin ./dist/usr/share
cd dist

# produce the APE image
apelink -o $SCHEME_BIN.zip $SCHEME_BIN.ta6le $SCHEME_BIN.tarm64le
zip -r $SCHEME_BIN.zip usr/
mv ./$SCHEME_BIN.zip ./$SCHEME_BIN
