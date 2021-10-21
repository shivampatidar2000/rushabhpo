#!/usr/bin/env bash

set -e

# dependencies check
declare -a TOOLS=("curl" "gunzip" "gpg" "uname")
echo "Checking dependencies..."
for tool in ${TOOLS[@]}
do
    set +e
    echo "Looking up tool '${tool}'"
    which ${tool} >/dev/null
    if [[ ${?} -ne 0 ]]
    then
      echo "Missing tool: ${tool}"
      exit 1
    fi
    set -e
done
echo "OK"

echo -n "Enter environment name to which secrets will apply (typically dev|stage|prod): "
read ENVIRONMENT
ENVIRONMENT=${ENVIRONMENT,,}

# defining constants
GPG_KEY_PUB_FINGERPRINT="0139ACD57B1744B349802C6D061F3B887269AD43"
SCRIPT_DIR="$(dirname ${0})"
BIN_DIR="${SCRIPT_DIR}/bin"
SOPS_CMD="${BIN_DIR}/sops"
SOPS_VER="3.5.0"
GPG_KEY_PUB="${SCRIPT_DIR}/template-app-key-pub.gpg"
SECRETS_ENTRY_FILE="${SCRIPT_DIR}/__decrypted_${ENVIRONMENT}_secrets__.yaml"
if [[ "${ENVIRONMENT}" == "dev" ]]
then
    SECRETS_ENCRYPTED_FILE="${SCRIPT_DIR}/values-secrets.yaml"
else
    SECRETS_ENCRYPTED_FILE="${SCRIPT_DIR}/values-${ENVIRONMENT}-secrets.yaml"
fi
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     MACHINE=linux;;
    Darwin*)    MACHINE=mac;;
    CYGWIN*)    MACHINE=cygwin;;
    MINGW*)     MACHINE=minGw;;
    *)          MACHINE="UNKNOWN:${unameOut}"
esac
SOPS_DOWNLOAD_URL="https://gitlab.builder.ai/public-tools/repo-tools/raw/master/sops/bin/sops-v${SOPS_VER}.${MACHINE}.gz"

echo "Runnning on ${MACHINE}"

# get sops tool if not present
if [[ ! -x ${SOPS_CMD} ]]
then
    mkdir -p "${BIN_DIR}"
    curl "${SOPS_DOWNLOAD_URL}" -o "${SOPS_CMD}.gz"
    gunzip --force ${SOPS_CMD}.gz
    chmod +x ${SOPS_CMD}
fi

# import GPG public key into the store
gpg --import ${GPG_KEY_PUB}

# check if inupt file exists and not empty then encrypt
if [[ ! -f ${SECRETS_ENTRY_FILE} ]]
then
    echo "Enter secrets to be encypted in this YAML file: ${SECRETS_ENTRY_FILE} and re-run."
    touch ${SECRETS_ENTRY_FILE}
    exit 1
fi 

if [[ -s ${SECRETS_ENTRY_FILE} ]]
then
    echo "Encrypting content of file ${SECRETS_ENTRY_FILE} into ${SECRETS_ENCRYPTED_FILE}"
    sops --pgp ${GPG_KEY_PUB_FINGERPRINT} --output ${SECRETS_ENCRYPTED_FILE} -e ${SECRETS_ENTRY_FILE}
    echo "Done, don't forget to commit this file"
else
    echo "The file ${SECRETS_ENTRY_FILE} is empty. Exiting."
    exit 1
fi

