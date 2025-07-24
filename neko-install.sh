#! /bin/bash

if [[ $(id -u) == 0 ]];
    if [[ $(command -v podman )]]; then
        NEKO_IMAGE="ghcr.io/m1k1o/neko/ungoogled-chromium:latest"
        ENV_URL="https://raw.githubusercontent.com/g4s/neko-deploy/refs/heads/main/assets/neko.env"
        ENV_FILE="/etc/sysconfig/neko"

        if [[ ! -f "${ENV_FILE}" ]]; then
            curl -fsSL "${ENV_URL}" --output "${ENV_FILE}"
            chmod 0644 "${ENV_FILE}"
        fi

        podman pull "${NEKO_IMAGE}"
        podman run --replace --privileged -d \
            --add-cap=SYS_ADMIN \
            --snm-size=2g \
            --label=app=neko \
            --label=dev.dozzle.group=neko \
            --label=tsdproxy.enable=tru \
            --env-file "${ENV_FILE}" \
            -e NEKO_WEBRTC_EPR= \
            -e NEKO_WEBRTC_NAT1TO1= \
            --name neko \
            "${NEKO_IMAGE}"
    else
        echo "This script requires podman present on host"
    fi
else
    echo "This script must run in privieged mode! ERROR"
fi