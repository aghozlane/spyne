
############# Base image ##################

# Start from a base image
FROM --platform=$BUILDPLATFORM ubuntu:focal AS build

# Define a system argument
ARG DEBIAN_FRONTEND=noninteractive

# Install system libraries of general use
RUN apt-get update --allow-releaseinfo-change && apt-get install --no-install-recommends -y \
    build-essential \ 
    iptables \
    libdevmapper1.02.1 \
    openjdk-11-jdk \
    ca-certificates-java \    
    python3.8 \
    python3-pip \
    python3-setuptools \
    python3-dev \
    docker.io \
    dpkg \
    sudo \
    wget \
    curl \
    dos2unix

############# Build Stage: Final ##################

# Build from the base image for prod
FROM ubuntu:focal as final

# Copy the build stage 
COPY --from=build / /

# Create working directory variable
ENV PROGRAM=/spyne

# Create working directory variable
ENV WORKDIR=/data

# Create a working directory in docker
RUN mkdir ${WORKDIR}

# Set up volume directory in docker
VOLUME ${WORKDIR}

# Set up volume directory in docker
VOLUME ${PROGRAM}

# Copy all scripts to docker images
COPY . ${PROGRAM}

############# Install bbtools ##################

# Set program directory as working directory to build required tools
WORKDIR ${PROGRAM}/bbtools

# Copy all files to docker images
COPY bbtools/install_bbtools.sh ${PROGRAM}/bbtools/install_bbtools.sh
COPY bbtools/bbtools_file.txt ${PROGRAM}/bbtools/bbtools_file.txt

# Convert bash script from Windows style line endings to Unix-like control characters
RUN dos2unix ${PROGRAM}/bbtools/install_bbtools.sh

# Allow permission to excute the bash script
RUN chmod a+x ${PROGRAM}/bbtools/install_bbtools.sh

# Execute bash script to wget the file and tar the package
RUN bash ${PROGRAM}/bbtools/install_bbtools.sh

############# Install python packages ##################

# Copy all files to docker images
COPY requirements.txt ${PROGRAM}/requirements.txt

# Install python requirements
RUN pip3 install --no-cache-dir -r ${PROGRAM}/requirements.txt

############# Permissions ##################

# Allow permission to read and write files to spyne directory
RUN chmod -R a+rwx ${PROGRAM}

# Allow permission to read and write files to spyne directory
RUN chmod -R a+rwx ${WORKDIR}

############# Run spyne ##################

# Set up working directory in docker
WORKDIR ${WORKDIR}

# Copy all files to docker images
COPY snake-kickoff ${PROGRAM}/snake-kickoff

# Convert spyne from Windows style line endings to Unix-like control characters
RUN dos2unix ${PROGRAM}/snake-kickoff

# Allow permission to excute the bash scripts
RUN chmod a+x ${PROGRAM}/snake-kickoff

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Export bash script to path
ENV PATH "$PATH:${PROGRAM}"
