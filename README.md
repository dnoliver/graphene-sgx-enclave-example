# Graphene SGX Enclave Example

This is a simplified version of the Graphene SGX
[nodejs](https://github.com/oscarlab/graphene/tree/master/Examples/nodejs) example, that runs in a
container.

## Build

```shell
docker build -t graphene-sgx .
```

## Run

`isgx` kernel module should be loaded:

```shell
modinfo isgx

filename:       /lib/modules/5.9.0-050900-generic/kernel/drivers/intel/sgx/isgx.ko
license:        Dual BSD/GPL
version:        2.11.0
author:         Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
description:    Intel SGX Driver
srcversion:     79ECED088645D8685839503
alias:          acpi*:INT0E0C:*
depends:        
retpoline:      Y
name:           isgx
vermagic:       5.9.0-050900-generic SMP mod_unload
```

`aesmd` service should be running:

```shell
systemctl status aesmd.service

● aesmd.service - Intel(R) Architectural Enclave Service Manager
     Loaded: loaded (/lib/systemd/system/aesmd.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2021-04-28 09:21:24 PDT; 4h 32min ago
   Main PID: 12478 (aesm_service)
      Tasks: 4 (limit: 9281)
     Memory: 4.9M
     CGroup: /system.slice/aesmd.service
             └─12478 /opt/intel/sgx-aesm-service/aesm/aesm_service
```

`vm.mmap_min_addr` should be set to `0`:

```shell
sysctl vm.mmap_min_addr=0
```

`docker` run arguments:

```shell
docker run \
    --rm \
    --device /dev/isgx \
    --volume /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \
    graphene-sgx
```

## Interactive

Run interactively for development:

```shell
docker run \
    --rm \
    -ti \
    --device /dev/isgx \
    --volume /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \
    --volume $(pwd):/root \
    graphene-sgx \
    bash
```
