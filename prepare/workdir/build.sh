# install packages
install_pkg=$(realpath "./install_pkg.sh")
include_pkg=''
exclude_pkg=''
bash $install_pkg -i -d $(realpath 'linglong/sources') -p $PREFIX -I \"$include_pkg\" -E \"$exclude_pkg\"
export LD_LIBRARY_PATH=$PREFIX/lib/$TRIPLET:$LD_LIBRARY_PATH

# build poppler
cd /project/linglong/sources/poppler.git
cmake -Bbuild \
      -DCMAKE_INSTALL_PREFIX=/project/linglong/sources/poppler.git/build_ins \
      -DCMAKE_INSTALL_LIBDIR=$PREFIX/lib/$TRIPLET \
      -DCMAKE_BUILD_TYPE=release
cd build
make -j$(nproc)
make install

# build TeXstudio
cd /project/linglong/sources/texstudio.git
mkdir build
cd build
. ../.github/scripts/get-version.sh
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX .. -Wno-dev
. ../git_revision.sh
cmake --build . --target install -- -j 2

# uninstall dev packages
bash $install_pkg -u -r '\-dev' -D
