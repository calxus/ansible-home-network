#!/bin/bash

# Creating file that enables SSH
if [ ! -f boot/ssh ]; then
    echo "Creating SSH file"
    touch boot/ssh
else
    echo "SSH file already exists, skipping."
fi

# Setting custom hostname to value passed to script
if grep -q "$1" rootfs/etc/hostname; then
    echo "Hostname already changed to: $(cat rootfs/etc/hostname)"
else
    echo "Setting hostname to: "$1
    echo "$1" > rootfs/etc/hostname
fi

# Enabling virtualization for containerd
if grep -q "cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" boot/cmdline.txt; then
    echo "Virtualization arguments already set, skipping."
else
    echo "Adding arguments for virtualization to boot"
    sed -i 's/$/ cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory/' boot/cmdline.txt
fi

# Optimizing GPU memory
if grep -q "gpu_mem=16" boot/config.txt; then
    echo "gpu_mem already set, skipping."
else
    echo "Setting gpu_mem to 16"
    sed -i '1s/^/gpu_mem=16\n/' boot/config.txt
fi
