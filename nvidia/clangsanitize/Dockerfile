FROM nvidia/cuda:10.0-devel-ubuntu18.04
LABEL alsvinn_version="from_disk_only_testing"
ARG ALSVINN_LOCATION
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

ENV CMAKE_MAJOR_VERSION 3
ENV CMAKE_MINOR_VERSION 12
ENV CMAKE_RELEASE_VERSION 2

ENV CC clang
ENV CXX clang++

ENV ALSVINN_IN_DOCKER 1

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

##### NETCDF
RUN export H5DIR=/usr/lib/mpich && \ 
   cd $HOME && \
    wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${NETCDF_VERSION}.tar.gz &&\
    tar xvf netcdf-${NETCDF_VERSION}.tar.gz && \
    cd netcdf-${NETCDF_VERSION} &&\
    export CPPFLAGS=-I${H5DIR}/include export CFLAGS=-L${H5DIR}/lib; \
    mkdir build;\
    cd build;\
    $INSTALL_PREFIX/bin/cmake .. -DCMAKE_C_COMPILER=`which $CC` -DCMAKE_CXX_COMPILER=`which $CXX` -DHDF5_DIR=/usr/include/hdf5/mpich -DHDF5_INCLUDE_DIR=/usr/include/hdf5/mpich -DHDF5_LIBRARY=/usr/lib/mpich/lib/libhdf5_mpich.so -DCMAKE_PREFIX_PATH=/usr/include/hdf5/mpich -DCMAKE_C_FLAGS='-I/usr/lib/mpich/include' -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX && \
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
RUN mkdir /root/alsvinn
COPY ${ALSVINN_LOCATION} /root/alsvinn
RUN cd $HOME; \
    export PATH=$HOME/local/bin:$PATH:$HOME/local/bin &&\
    cd $HOME&&\
    cd alsvinn &&\
    mkdir build &&\
    cd build &&\
    $INSTALL_PREFIX/bin/cmake .. -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX} \
    	  -DCMAKE_BUILD_TYPE=Debug \
	  -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc \
	  -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
	  -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython2.7.so.1 \
	  -DPYTHON_INCLUDE_DIR=/usr/include/python2.7 \
	  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
	  -DCMAKE_C_COMPILER=`which $CC` \
	  -DCMAKE_CXX_COMPILER=`which $CXX`\
	  -DCMAKE_CXX_FLAGS='-fsanitize=memory -stdlib=libc++ -lc++abi'&&\
    make && \
    make install
    
RUN rm /etc/ld.so.cache && ldconfig
ENTRYPOINT ["alsuqcli"]