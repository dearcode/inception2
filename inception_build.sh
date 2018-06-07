#!/bin/bash

debug_dir=$1
platform=$2

if [ $# -eq 1 ]
then 
	echo "building project in $1"
	platform="x"
elif [ $# -ne 2 ]
then
	echo "Usage: $0 builddir [platform(linux:Xcode)]"
	echo "EXAPMLE: $0 debug [Xcode]"
	exit
fi

Gplatform=""
makerule=""
if [ $platform == "Xcode" ]
then
    Gplatform="-G Xcode"
else
    makerule="make -j4 install"
fi

if [ -d $debug_dir ]
then
  cd $debug_dir
else
  mkdir $debug_dir
  cd $debug_dir

  # cmake && make && make install
  cmake -DWITH_DEBUG=ON -DCMAKE_INSTALL_PREFIX=./mysql  -DMYSQL_DATADIR=./mysql/data -DCMAKE_C_FLAGS_DEBUG="-DDBUG_ON" \
    -DWITH_SSL=bundled -DCMAKE_BUILD_TYPE=Debug -DWITH_ZLIB=bundled \
    -DMY_MAINTAINER_CXX_WARNINGS="-Wall -Wextra -Wunused -Wwrite-strings -Wno-strict-aliasing  -Wno-unused-parameter -Woverloaded-virtual -Wno-sizeof-pointer-memaccess" \
    $Gplatform\
    ..
fi

if [ $platform != "Xcode" ]
then
    $makerule
fi

