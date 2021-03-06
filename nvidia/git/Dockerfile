FROM nvidia/cuda:9.1-devel-ubuntu16.04
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
ENV BOOST_MINOR_VERSION 68
ENV BOOST_RELEASE_VERSION 0

ENV HDF5_VERSION 1.10.5

ENV CMAKE_MAJOR_VERSION 3
ENV CMAKE_MINOR_VERSION 14
ENV CMAKE_RELEASE_VERSION 0
ENV GCC_VERSION 5
ENV CC gcc-${GCC_VERSION}
ENV CXX g++-${GCC_VERSION}

ENV ALSVINN_IN_DOCKER 1

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
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
    python3\
    python-dev \
    libcurl4-openssl-dev \
    zlib1g-dev\
    curl\
    cuda-tools-9-1\
    cuda-toolkit-9-1\
    cuda-misc-headers-9-1\
    cuda-libraries-dev-9-1\
    cuda-cudart-dev-9-1 \
    cuda-core-9-1\
    cuda-cublas-9-1\
    cuda-cufft-dev-9-1\
    cuda-cupti-9-1\
    cuda-curand-9-1\
    cuda-cuobjdump-9-1\
    cuda-cusolver-9-1\
    cuda-cusparse-9-1\
    cuda-driver-dev-9-1\
    cuda-gdb-9-1\
    cuda-npp-dev-9-1\
    cuda-nvgraph-dev-9-1\
    cuda-nvml-dev-9-1\
    cuda-nvrtc-dev-9-1\
    cuda-runtime-9-1\
    cuda-visual-tools-9-1
    
    
    

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && python3 get-pip.py && pip3 install numpy matplotlib jupyter matplotlib2tikz scipy GitPython dicttoxml



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
RUN cd $HOME&&\
    export CC=${INSTALL_PREFIX}/bin/mpicc&&\
    wget -O hdf5.tar.bz2 "https://www.hdfgroup.org/package/hdf5-${HDF5_VERSION}-tar-bz2/?wpdmdl=13570&refresh=5c90e67332c151553000051" &&\
    tar xvf hdf5.tar.bz2&&\
    cd hdf5-${HDF5_VERSION} &&\
    ./configure --prefix=$INSTALL_PREFIX --enable-mpi --enable-parallel --disable-cpp-lib&&\
    make install&&\
    rm -rf hdf5*

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

RUN apt-cache search cuda

ARG ALSVINN_GIT_VERSION=master
RUN cd $HOME; \	
    git clone --recursive https://github.com/alsvinn/alsvinn.git; \
    export PATH=$HOME/local/bin:$PATH:$HOME/local/bin &&\
    cd $HOME&&\
    cd alsvinn &&\
    git checkout ${ALSVINN_GIT_VERSION} &&\
    mkdir build &&\
    cd build &&\
    $INSTALL_PREFIX/bin/cmake .. -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX} \
    	  -DCMAKE_BUILD_TYPE=Release \
    	  -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc \
    	  -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-9.1	  \
    	  -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython2.7.so.1 \
    	  -DPYTHON_INCLUDE_DIR=/usr/include/python2.7 \
    	  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX  \
    	  -DCMAKE_C_COMPILER=`which $CC` \
    	  -DCMAKE_CXX_COMPILER=`which $CXX`&& \
    make VERBOSE=1&& \
    make install &&\
    echo 'Finished'

# We also want to compile the examples
RUN cd $HOME/alsvinn &&\
    cd library_examples/alsuq &&\
    cd only_statistics &&\
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release &&\
    make && \
    cd ../.. && \
    cd generate_parameters && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release &&\
    make &&\
    cp generate_parameters /usr/local/bin/
    
    
# shifter doesn't like these libraries
#RUN rm /usr/lib/libmpifort* && rm /usr/lib/libmpicxx*

RUN rm /etc/ld.so.cache && ldconfig
RUN ldconfig
ENTRYPOINT ["alsuqcli"]