
# Create a build argument
ARG TARGETPLATFORM

############# Base image ##################

# Start from a base image
FROM ubuntu:focal AS base

# local apt mirror support
# start every stage with updated apt sources
ARG APT_MIRROR_NAME=
RUN if [ -n "$APT_MIRROR_NAME" ]; then sed -i.bak -E '/security/! s^https?://.+?/(debian|ubuntu)^http://'"$APT_MIRROR_NAME"'/\1^' /etc/apt/sources.list && grep '^deb' /etc/apt/sources.list; fi
RUN apt-get update --allow-releaseinfo-change

############# Build Stage: Dependencies ##################

FROM base AS build
SHELL ["/bin/bash", "-c"]

# Define a system argument
ARG DEBIAN_FRONTEND=noninteractive

# Install system libraries of general use
RUN apt-get install --no-install-recommends -y \
    build-essential \ 
    iptables \
    libdevmapper1.02.1 \
    openjdk-11-jdk ca-certificates-java \
    python3.7\
    python3-pip \
    python3-setuptools \
    python3-dev \
    dpkg \
    sudo \
    wget \
    curl \
    dos2unix

############# Build Stage: Final ##################

# Build from the base image for prod
FROM build as final

# Create working directory variable
ENV PROGRAM=/spyne

# Create working directory variable
ENV WORKDIR=/data

# Copy all scripts to docker images
COPY . ${PROGRAM}

# Set up volume directory in docker
VOLUME ${WORKDIR}

############# Install bbtools ##################

# Set program directory as working directory to build required tools
WORKDIR ${PROGRAM}/bbtools

# Copy all files to docker images
COPY bbtools/* .

# Convert bash script from Windows style line endings to Unix-like control characters
RUN dos2unix ./install_bbtools.sh

# Allow permission to excute the bash script
RUN chmod a+x ./install_bbtools.sh

# Execute bash script to wget the file and tar the package
RUN bash ./install_bbtools.sh

############# Install Docker ##################

# Set program directory as working directory to build required tools
WORKDIR ${PROGRAM}/docker

# Copy all files to docker images
COPY docker/* .

# Convert bash script from Windows style line endings to Unix-like control characters
RUN dos2unix ./install_docker.sh

# Allow permission to excute the bash script
RUN chmod a+x ./install_docker.sh

# Execute bash script to wget the file and tar the package
RUN bash ./install_docker.sh

############# Install python packages ##################

# Copy all files to docker images
COPY requirements.txt ${PROGRAM}/requirements.txt

# Install python requirements
RUN pip3 install --no-cache-dir -r ${PROGRAM}/requirements.txt

############# Run spyne ##################

# Set up working directory in docker
WORKDIR ${WORKDIR}

# Copy all files to docker images
COPY snake-kickoff ${PROGRAM}/snake-kickoff

# Convert spyne from Windows style line endings to Unix-like control characters
RUN dos2unix ${PROGRAM}/snake-kickoff

# Allow permission to excute the bash scripts
RUN chmod a+x ${PROGRAM}/snake-kickoff

# Allow permission to read and write files to spyne directory
RUN chmod -R a+rwx ${PROGRAM}

# Allow permission to read and write files to current working directory
RUN chmod -R a+rwx ${WORKDIR}

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Export bash script to path
ENV PATH "$PATH:${PROGRAM}"
