FROM ubuntu:latest

MAINTAINER Pierrick Roger (pierrick.roger@gmail.com)

# Install CFM-ID into a docker container image.
# Code adapted from `https://sourceforge.net/p/cfm-id/wiki/Home/#on-linux`.

# Update and upgrade system
RUN apt-get update
RUN apt-get -y upgrade

# Install packages
RUN apt-get -y install cmake
RUN apt-get -y install g++
RUN apt-get -y install libboost-all-dev
RUN apt-get -y install wget
RUN apt-get -y install zip
RUN apt-get -y install git
RUN apt-get -y install subversion

# Install RDKit
WORKDIR /sources
RUN git clone --recursive https://github.com/rdkit/rdkit
WORKDIR /sources/rdkit
RUN cd External/INCHI-API && bash download-inchi.sh
WORKDIR /sources/rdkit/build
RUN cmake .. -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DRDK_BUILD_INCHI_SUPPORT=ON
RUN make install
ENV RDBASE='/sources/rdkit'

# Install LPSolve
WORKDIR /sources
RUN wget -q https://sourceforge.net/projects/lpsolve/files/lpsolve/5.5.2.3/lp_solve_5.5.2.3_source.tar.gz
RUN tar -zxf lp_solve_5.5.2.3_source.tar.gz
RUN cd lp_solve_5.5/lpsolve55 && ./ccc

# Install CFM
WORKDIR /sources
RUN svn checkout svn://svn.code.sf.net/p/cfm-id/code/cfm cfm
WORKDIR /sources/cfm/build
RUN cmake .. -DLPSOLVE_INCLUDE_DIR=/sources/lp_solve_5.5 -DLPSOLVE_LIBRARY_DIR=/sources/lp_solve_5.5/lpsolve55/bin/ux64

# Clean up
WORKDIR /sources
RUN apt-get clean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Define Entry point script
# TODO write a cfm-script that can call all other scripts
#ENTRYPOINT ["/usr/bin/cfm-script"]
