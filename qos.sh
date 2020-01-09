#!/bin/bash

# to exit the script execution if user is not root

if [ ${USER} != "root" ]

then

    echo "${0}: Permission denied" 1>&2

    exit 1
fi

# setting environment variables needed for setup and execution

export RTE_SDK="${HOME}/Desktop/work/DPDK/dpdk-stable-18.11.3"  # set the path to the DPDK root directory on your system
export RTE_TARGET="x86_64-native-linuxapp-gcc"
export DESTDIR="${RTE_SDK}"

# running expect script to set up devices and hugepages

expect script2.exp

#defining parameters for qos_sched

VIRTUAL_INTERFACES+=" --vdev=net_tap0,iface=eth4" # set the PCIe addresses of the ports bound to uio module
VIRTUAL_INTERFACES+=" --vdev=net_tap1,iface=eth5"

EAL_PARAMS=" -l 0,1,2 ${VIRTUAL_INTERFACES}"
DPDK_APP="${RTE_SDK}/examples/qos_sched/build/qos_sched"

# compiling the sample application

cd ${DESTDIR}/examples/qos_sched;
make;

#running the same application and writing output to a file
# the msz value is hardcoded, change it accordingly
DPDK_APP_PARAMS=" --pfc \"0,1,1,2\" --mst 0 --msz 16384 --cfg ${RTE_SDK}/examples/qos_sched/profile.cfg" #change the path to the profile.cfg

#uncomment the ts to get the timestamps

${DPDK_APP} ${EAL_PARAMS} -- ${DPDK_APP_PARAMS} #| ts '[%H:%M:%.S]' | tee -a log.txt

pid=$!

echo $pid

wait $pid

