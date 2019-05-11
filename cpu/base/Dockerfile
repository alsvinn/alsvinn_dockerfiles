FROM ubuntu:19.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --yes libnetcdf-mpi-dev build-essential \
    	cmake python3 python3-matplotlib python3-numpy python3-scipy git \
	libopenmpi-dev gcc g++ libgtest-dev libboost-all-dev doxygen graphviz \
	libhdf5-mpi-dev libpnetcdf-dev \
	nvidia-cuda-dev nvidia-cuda-toolkit 

# RUN git clone --recursive https://github.com/alsvinn/alsvinn.git &&\
#     cd alsvinn &&\
#     mkdir build &&\
#     cd build &&\
#     cmake .. -DCMAKE_BUILD_TYPE=Release -DALSVINN_PYTHON_VERSION=3.7 &&\
#     make install
     

	