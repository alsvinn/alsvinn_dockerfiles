FROM ubuntu:19.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --yes libnetcdf-dev libnetcdf-mpi-dev build-essential \
    	cmake python3 python3-matplotlib python3-numpy python3-scipy git \
	libopenmpi-dev gcc g++ libgtest-dev libboost-all-dev doxygen graphviz \
	libhdf5-mpi-dev libpnetcdf-dev python3-ipykernel \
	jupyter-notebook python3-notebook python3-pip python3-git \
	python3-netcdf4 python3-dicttoxml

RUN pip3 install matplotlib2tikz
	
	


	