#! /bin/bash

if [[ $(id -u) == 0 ]];
    if [[ $(command -v podman )]]; then
        NEKO_IMAGE="ghcr.io/m1k1o/neko/ungoogled-chromium:latest"
        ENV_FILE="/etc/sysconfig/neko"

        podman pull "${NEKO_IMAGE}"
        podman run --replace --privileged \
            --label=app=neko \
            --label=dev.dozzle.group=neko \
            --label=tsdproxy.enable=tru \
            --env-file "${ENV_FILE}" \
            --name neko \
            "${NEKO_IMAGE}"
    else
        "This script requires podman present on host"
    fi
else
    echo "This script must run in privieged mode! ERROR"
fi