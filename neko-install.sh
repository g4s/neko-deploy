#! /bin/bash

if [[ $(id -u) == 0 ]];
    if [[ $(command -v podman )]]; then
        NEKO_IMAGE="ghcr.io/m1k1o/neko/ungoogled-chromium:latest"
        ASSET_BASE="https://raw.githubusercontent.com/g4s/neko-deploy/refs/heads/main/assets"
        ENV_FILE="/etc/sysconfig/neko"
        HOST_FILE="/etc/neko/hosts"
        LABEL_FILE="/etc/neko/labels"
        POLICIES_FILE="/etc/neko/policies.json"

        if [[ ! -f "${ENV_FILE}" ]]; then
            curl -fsSL "${ASSET_BASE}/neko.env" --output "${ENV_FILE}"
            chmod 0644 "${ENV_FILE}"
        fi

        mkdir -p /etc/neko
        curl -fsSL "${ASSET_BASE}/labels" --output "${LABEL_FILE}"
        curl -fsSL "${ASSET_BASE}/plicies.json" --output "${POLICIES_FILES}"

        # loading additional host mappings for container
        ADDITIONAL_HOSTS=""
        if [[ ! -f "${HOST_FILE}" ]]; then
            curl -fsSL "${ASSET_BASE}/hosts" --output "${HOST_FILE}"
            chmod 0644 "${HOST_FILE}"

            wbile IFS= read -r line; do
                ADDITIONAL_HOSTS+="--add-host ${line} \\"
            done < "$HOST_FILE"
        else
            while IFS= read -r line; do
                ADDITIONAL_HOSTS+="--add-host ${line} \\"
            done < "$HOST_FIFLE"
        fi

        podman pull "${NEKO_IMAGE}"
        podman run --replace --privileged -d \
            --add-cap=SYS_ADMIN \
            --snm-size=2g \
            --cpus=6 \
            --label-file="${LABEL_FILE}" \
            "${ADDITIONAL_HOSTS}" \
            --env-file "${ENV_FILE}" \
            -e NEKO_WEBRTC_EPR= \
            -e NEKO_WEBRTC_NAT1TO1= \
            -v "${POLICIES_FILE}":/etc/chromium/policies/managed/policies.json:Z \
            --name neko \
            "${NEKO_IMAGE}"
    else
        echo "This script requires podman present on host"
    fi
else
    echo "This script must run in privieged mode! ERROR"
fi