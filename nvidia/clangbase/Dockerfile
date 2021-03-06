FROM nvidia/cuda:10.0-devel-ubuntu18.04
LABEL alsvinn_version="from_disk_only_testing"

##### NOTE: We want to use MPICH, since it is the "native" supported MPI library for most clusters
##### (on Cray clusters they usually replace the mpich library with their own in the docker/shifter container)
##### Because of this, we need to compile some packages ourselves, even though they come with ubuntu
##### (but only with openmpi support)
ENV INSTALL_PREFIX /usr/local


ENV PNETCDF_VERSION 1.10.0
ENV NETCDF_VERSION 4.6.1
ENV GTEST_VERSION 1.8.0

ENV BOOST_MAJOR_VERSION 1
ENV BOOST_MINOR_VERSION 68
ENV BOOST_RELEASE_VERSION 0

ENV CMAKE_MAJOR_VERSION 3
ENV CMAKE_MINOR_VERSION 13
ENV CMAKE_RELEASE_VERSION 1

ENV CC clang
ENV CXX clang++

ENV ALSVINN_IN_DOCKER 1

ARG EXTRA_CFLAGS=""

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    cmake\
    build-essential\
    wget\
    doxygen\
    clang\
    libomp-dev\
    libmpich-dev\
    m4\
    unzip\
    libc++-dev\
    libc++abi-dev\
    cuda-compiler-10-0\
    python\
    python-matplotlib \
    python-numpy\
    python-scipy\
    python-dev \
    libgtest-dev \
    libhdf5-mpich-dev \
    libcurl4-openssl-dev

##### CMAKE
RUN cd $HOME &&\
    wget https://cmake.org/files/v${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}/cmake-${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_RELEASE_VERSION}.tar.gz &&\
    tar xvf cmake-${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_RELEASE_VERSION}.tar.gz &&\
    cd cmake-${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_RELEASE_VERSION} && \
    ./bootstrap --system-curl --prefix=$INSTALL_PREFIX && \
    make && \
    make install && \
    cd $HOME &&\
    rm -rf cmake*

RUN echo ${EXTRA_CFLAGS}
##### NETCDF
RUN export H5DIR=/usr/lib/mpich && \ 
   cd $HOME && \
    wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${NETCDF_VERSION}.tar.gz &&\
    tar xvf netcdf-${NETCDF_VERSION}.tar.gz && \
    cd netcdf-${NETCDF_VERSION} &&\
    mkdir build;\
    cd build;\
    $INSTALL_PREFIX/bin/cmake .. -DCMAKE_C_COMPILER=`which $CC` -DCMAKE_LINKER='lld' -DCMAKE_CXX_COMPILER=`which $CXX` -DHDF5_DIR=/usr/include/hdf5/mpich -DHDF5_INCLUDE_DIR=/usr/include/hdf5/mpich -DHDF5_LIBRARY=/usr/lib/mpich/lib/libhdf5_mpich.so -DCMAKE_PREFIX_PATH=/usr/include/hdf5/mpich -DCMAKE_C_FLAGS="-I/usr/lib/mpich/include ${EXTRA_CFLAGS}" -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX && \
    make install &&\
    cd ../.. &&\
    rm -rf netcdf*

##### PNETCDF
RUN cd ~ && \
    wget http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/parallel-netcdf-${PNETCDF_VERSION}.tar.gz &&\
    export CC=`which mpicc`;\
    tar xvf parallel-netcdf-${PNETCDF_VERSION}.tar.gz &&\
    cd parallel-netcdf-${PNETCDF_VERSION} &&\
    export CFLAGS='-fPIC' &&\
    ./configure --prefix=$INSTALL_PREFIX &&\
    make install &&\
    cd $HOME &&\
    rm -rf parallel-netcdf*

##### GTest
RUN cd $HOME &&\
    wget https://github.com/google/googletest/archive/release-${GTEST_VERSION}.zip &&\
    unzip release-${GTEST_VERSION}.zip &&\
    cd googletest-release-${GTEST_VERSION} &&\
    mkdir build &&\
    cd build &&\
    $INSTALL_PREFIX/bin/cmake .. -DCMAKE_CXX_FLAGS="-stdlib=libc++ -lc++abi ${EXTRA_CFLAGS}" -DCMAKE_EXE_LINKER_FLAGS='-stdlib=libc++ -lc++abi' -DCMAKE_LINKER='lld' -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DCMAKE_C_COMPILER=`which $CC` -DCMAKE_CXX_COMPILER=`which $CXX`&&\
    make install &&\
    find . -iname '*.a' -exec cp {} ${INSTALL_PREFIX}/lib/ \; &&\
    cd $HOME &&\
    rm -rf release-${GTEST_VERSION}.zip googletest-release-${GTEST_VERSION}




##### Boost
RUN cd $HOME &&\
    wget https://dl.bintray.com/boostorg/release/${BOOST_MAJOR_VERSION}.${BOOST_MINOR_VERSION}.${BOOST_RELEASE_VERSION}/source/boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}.tar.bz2 && \
    tar xvf boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}.tar.bz2 && cd boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION} && \
    ./bootstrap.sh --with-python=`which python` --prefix=$INSTALL_PREFIX && \
    ./b2 --build-type=complete toolset=clang cxxflags="${EXTRA_CFLAGS} -stdlib=libc++" linkflags="-stdlib=libc++" --layout=tagged install && \
    cd $HOME && \
    rm -rf boost_*
