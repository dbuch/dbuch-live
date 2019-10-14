#!/usr/bin/sh

qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 -drive file=./out/dbuch-live-2019.10-x86_64.iso,if=virtio,media=disk,format=raw
