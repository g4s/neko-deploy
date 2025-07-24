#! /bin/bash

if [[ $(id -u) == 0 ]];
    if [[ $(command -v podman )]]; then

        podman run --replace --privileged \
            --label=app=neko \
            --label=dev.dozzle.group=neko
    else
        "This script requires podman present on host"
    fi
else
    echo "This script must run in privieged mode! ERROR"
fi