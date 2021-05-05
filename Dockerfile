FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    bison \
    gawk \
    meson \
    python3-click \
    python3-jinja2

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libprotobuf-c-dev \
    protobuf-c-compiler \
    python3-pip \
    python3-protobuf && \
    python3 -m pip install toml>=0.10

RUN apt-get update && apt-get install -y \
    git \
    wget

RUN mkdir /opt/intel && \
    git clone https://github.com/intel/linux-sgx-driver /opt/intel/linux-sgx-driver

RUN git clone https://github.com/oscarlab/graphene --depth 10 /opt/oscarlab/graphene

WORKDIR /opt/oscarlab/graphene

RUN openssl genrsa -3 -out ./Pal/src/host/Linux-SGX/signer/enclave-key.pem 3072 

RUN make SGX=1 ISGX_DRIVER_PATH=/opt/intel/linux-sgx-driver -j$(nproc) && \
    meson build -Ddirect=disabled -Dsgx=enabled && \
    ninja -C build && \
    ninja -C build install

ENV PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.8/site-packages/

ARG DEBIAN_FRONTEND=noninteractive

ARG TZ=America/Los_Angeles

RUN apt-get update && apt-get install -y \
    nodejs \
    npm

CMD bash
