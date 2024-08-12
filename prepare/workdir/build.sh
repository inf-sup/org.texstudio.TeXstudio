# install packages
install_pkg=$(realpath "./install_pkg.sh")
include_pkg='liblcms2-2'
exclude_pkg=''
bash $install_pkg -i -d $(realpath 'linglong/sources') -p $PREFIX -I \"$include_pkg\" -E \"$exclude_pkg\"
export LD_LIBRARY_PATH=$PREFIX/lib/$TRIPLET:$LD_LIBRARY_PATH

# build poppler
cd /project/linglong/sources/poppler.git
cmake -Bbuild \
      -DCMAKE_INSTALL_PREFIX=/project/linglong/sources/poppler.git/build_ins \
      -DCMAKE_INSTALL_LIBDIR=$PREFIX/lib/$TRIPLET \
      -DCMAKE_BUILD_TYPE=release \
      -DENABLE_QT6=OFF
cd build
make -j$(nproc)
make install

# build TeXstudio
cd /project/linglong/sources/texstudio.git
sed -i '474c \		REGEX .*en_US.*|.*fr_FR.*|.*ru_RU.*' CMakeLists.txt
mkdir build
cd build
. ../.github/scripts/get-version.sh
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX .. -Wno-dev
. ../git_revision.sh
cmake --build . --target install -- -j 2

# uninstall dev packages
bash $install_pkg -u -r '\-dev' -D

rm -r $PREFIX/lib/$TRIPLET/pkgconfig $PREFIX/share/pkgconfig $PREFIX/share/man $PREFIX/share/doc
strip -s $PREFIX/bin/* $PREFIX/lib/$TRIPLET/*
