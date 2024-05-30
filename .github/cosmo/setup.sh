COSMOCC_VERSION=3.3.10
COSMOCC_ZIP=/opt/cosmocc/cosmocc-$COSMOCC_VERSION.zip
COSMOCC_SHA256="00d61c1215667314f66e288c8285bae38cc6137fca083e5bba6c74e3a52439de"

function fail_sha
{
    >&2 echo "Downloaded file ${1} SHA256 does not match known hash."
    exit 1
}

sudo mkdir -p /opt/cosmocc
sudo chown -R "$(id -u):$(id -g)" /opt

wget -O $COSMOCC_ZIP "https://cosmo.zip/pub/cosmocc/cosmocc-${COSMOCC_VERSION}.zip"
(echo "${COSMOCC_SHA256} ${COSMOCC_ZIP}" | sha256sum --check --status) || fail_sha $COSMOCC_ZIP

unzip $COSMOCC_ZIP -d /opt/cosmocc/


