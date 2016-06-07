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
RUN apt-get -y install libboost-dev
RUN apt-get -y install wget
RUN apt-get -y install zip
RUN apt-get -y install git

# Install RDKit
WORKDIR /sources
RUN git clone --recursive https://github.com/rdkit/rdkit
WORKDIR /sources/rdkit
RUN cd External/INCHI-API && bash download-inchi.sh
WORKDIR /sources/rdkit/build
RUN cmake .. -DRDK_BUILD_PYTHON_WRAPPERS=OFF -DRDK_BUILD_INCHI_SUPPORT=ON

# Install LPSolve

# Clean up
RUN apt-get clean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Define Entry point script
# TODO write a cfm-script that can call all other scripts
#ENTRYPOINT ["/usr/bin/cfm-script"]
