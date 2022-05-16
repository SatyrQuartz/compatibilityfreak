#!/bin/bash
all_args=("$@")
first_arg=$1
rest_args=("${all_args[@]:1}")
LD_LIBRARY_PATH=/emuroot/arm-linux-gnueabihf/usr/lib/arm-linux-gnueabihf/:/emuroot/arm-linux-gnueabihf/usr/lib/arm-linux-gnueabihf/pulseaudio/ /usr/libexec/houdini $all_args . $rest_args
