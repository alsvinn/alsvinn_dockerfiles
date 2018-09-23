FROM nvidia/cuda:8.0-devel-ubuntu16.04
LABEL alsvinn_version="git"

##### NOTE: We want to use MPICH, since it is the "native" supported MPI library for most clusters
##### (on Cray clusters they usually replace the mpich library with their own in the docker/shifter container)
##### Because of this, we need to compile some packages ourselves, even though they come with ubuntu
##### (but only with openmpi support)
ENV INSTALL_PREFIX /usr/local


ENV PNETCDF_VERSION 1.10.0
ENV NETCDF_VERSION 4.6.1
ENV GTEST_VERSION 1.8.0

ENV BOOST_MAJOR_VERSION 1
ENV BOOST_MINOR_VERSION 66
ENV BOOST_RELEASE_VERSION 0

ENV HDF5_VERSION 1.8.20

ENV CMAKE_MAJOR_VERSION 3
ENV CMAKE_MINOR_VERSION 12
ENV CMAKE_RELEASE_VERSION 2
ENV GCC_VERSION 5
ENV CC gcc-${GCC_VERSION}
ENV CXX g++-${GCC_VERSION}

ENV ALSVINN_IN_DOCKER 1

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    cmake\
    build-essential\
    wget\
    doxygen\
    clang\
    libomp-dev\
    m4\
    unzip\
    cuda-compiler-9-2\
    python\
    python-matplotlib \
    python-numpy\
    python-scipy\
    python-dev \
    libcurl4-openssl-dev \
    zlib1g-dev


# RUN apt-get update && \
#     apt-get install build-essential software-properties-common -y && \
#     add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
#     apt-get update && \
#     apt-get install gcc-${GCC_VERSION} g++-${GCC_VERSION} -y&&\
#     update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${GCC_VERSION} ${GCC_VERSION}0 --slave /usr/bin/g++ g++ /usr/bin/g++-${GCC_VERSION}

#### MPICH 
RUN cd $HOME;\
    wget https://github.com/pmodels/mpich/archive/v3.1.4.tar.gz&&\ 
    DEBIAN_FRONTEND=noninteractive apt-get install -y libtool autoconf&&\
    tar xvf v3.1.4.tar.gz&&\
    cd mpich-3.1.4&&\
    ./autogen.sh&&\
    ./configure --prefix=$INSTALL_PREFIX --disable-fortran&&\
    make install



#### HDF5
# RUN cd $HOME;\
#     export CC=${INSTALL_PREFIX}/bin/mpicc&&\
#     wget https://support.hdfgroup.org/ftp/HDF5/current18/src/CMake-hdf5-${HDF5_VERSION}.tar.gz&&\
#     tar xvf CMake-hdf5-${HDF5_VERSION}.tar.gz&&\
#     cd CMake-hdf5-${HDF5_VERSION} &&\
#     tar xvf SZip.tar.gz &&\
#     cd SZip &&\
#     mkdir build&&\
#     cd build&&\
#     cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$INSTALL_PREFIX -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DDISABLE_FORTRAN=ON -DHDF5_BUILD_CPP_LIB=OFF&&\
#     make install&&\
#     cd ..&&\
#     cd ..&&\
#     tar xvf ZLib.tar.gz&&\
#     cd ZLib &&\
#     mkdir build&&\
#     cd build&&\
#     cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$INSTALL_PREFIX -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX  -DDISABLE_FORTRAN=ON &&\
#     make install &&\
#     cd ..&&\
#     cd ..&&\
#     cd hdf5-${HDF5_VERSION}&&\
#     mkdir build&&\
#     cd build&&\
#     cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$INSTALL_PREFIX -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX   -DDISABLE_FORTRAN=ON -DHDF5_ENABLE_PARALLEL=ON -DHDF5_BUILD_CPP_LIB=OFF&&\
#     make install


RUN cd $HOME;\
    export CC=${INSTALL_PREFIX}/bin/mpicc&&\
    wget https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-${HDF5_VERSION}.tar.gz&&\
    tar xvf hdf5-${HDF5_VERSION}.tar.gz&&\
    cd hdf5-${HDF5_VERSION} &&\
    ./configure --prefix=$INSTALL_PREFIX --enable-mpi --enable-parallel --disable-cpp-lib&&\
    make install

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

##### NETCDF
RUN cd $HOME && \
    export CC=${INSTALL_PREFIX}/bin/mpicc&&\	
    wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${NETCDF_VERSION}.tar.gz &&\
    tar xvf netcdf-${NETCDF_VERSION}.tar.gz && \
    cd netcdf-${NETCDF_VERSION} &&\
    mkdir build;\
    cd build;\
    $INSTALL_PREFIX/bin/cmake .. -DCMAKE_C_COMPILER=`which $CC` -DCMAKE_CXX_COMPILER=`which $CXX` -DHDF5_DIR=/usr/local -DHDF5_INCLUDE_DIR=/usr/local/include -DHDF5_LIBRARY=/usr/local/lib/libhdf5.so -DCMAKE_PREFIX_PATH=/usr/local -DCMAKE_C_FLAGS='-I/usr/local/include' -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX && \
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
    $INSTALL_PREFIX/bin/cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DCMAKE_C_COMPILER=`which $CC` -DCMAKE_CXX_COMPILER=`which $CXX`&&\
    make install &&\
    find . -iname '*.a' -exec cp {} ${INSTALL_PREFIX}/lib/ \; &&\
    cd $HOME &&\
    rm -rf release-${GTEST_VERSION}.zip googletest-release-${GTEST_VERSION}





RUN cd $HOME &&\
    wget https://dl.bintray.com/boostorg/release/${BOOST_MAJOR_VERSION}.${BOOST_MINOR_VERSION}.${BOOST_RELEASE_VERSION}/source/boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}.tar.bz2 && \
    tar xvf boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION}.tar.bz2 && cd boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_RELEASE_VERSION} && \
    ./bootstrap.sh --with-python=`which python` --prefix=$INSTALL_PREFIX && \
    ./b2 --build-type=complete --toolset=$CC --layout=tagged install && \
    cd $HOME && \
    rm -rf boost_*

# ENV ALSVINN_CUDA_PKG_VERSION 9-2
# RUN apt-get update && apt-get install -y --no-install-recommends \
#         cuda-core-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-misc-headers-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-command-line-tools-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-nvrtc-dev-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-nvml-dev-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-nvgraph-dev-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-cusolver-dev-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-cublas-dev-8-0=8.0.61.2-1 \
#         cuda-cufft-dev-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-curand-dev-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-cusparse-dev-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-npp-dev-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-cudart-dev-$ALSVINN_CUDA_PKG_VERSION \
#         cuda-driver-dev-$ALSVINN_CUDA_PKG_VERSION && \
#     rm -rf /var/lib/apt/lists/*




    
    
RUN cd $HOME; \	
    git clone --recursive https://github.com/alsvinn/alsvinn.git; \
    export PATH=$HOME/local/bin:$PATH:$HOME/local/bin &&\
    cd $HOME&&\
    cd alsvinn &&\
    mkdir build &&\
    cd build &&\
    $INSTALL_PREFIX/bin/cmake .. -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX} \
    	  -DCMAKE_BUILD_TYPE=Release \
    	  -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc \
    	  -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0	  \
    	  -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython2.7.so.1 \
    	  -DPYTHON_INCLUDE_DIR=/usr/include/python2.7 \
    	  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX  \
    	  -DCMAKE_C_COMPILER=`which $CC` \
    	  -DCMAKE_CXX_COMPILER=`which $CXX`&& \
    make VERBOSE=1&& \
    make install &&\
    echo 'Finished'
    
# shifter doesn't like these libraries
#RUN rm /usr/lib/libmpifort* && rm /usr/lib/libmpicxx*

RUN rm /etc/ld.so.cache && ldconfig
RUN ldconfig
ENTRYPOINT ["alsuqcli"]