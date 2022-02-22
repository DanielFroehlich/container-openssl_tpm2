# Provision a private key inside the TPM
# and generate a cert for it.
# The key and cert are stored via hostPath on the host, as it is
# specfic to the TPM of the host.



#Good practice is to generate the RSA version of the primary storage seed and place it at well known location 81000001 (Microsoft Spec).
HANDLE=$(TPM_DEVICE=/dev/tpm0 tsscreateprimary -hi o -st -rsa | cut -d ' ' -f 2)
echo "Generate the RSA version of the primary storage seed - 'object already defined' message can be ignored"
TPM_DEVICE=/dev/tpm0 tssevictcontrol -hi o -ho $HANDLE -hp 81000001
TPM_DEVICE=/dev/tpm0 tssflushcontext -ha $HANDLE

echo "Creating private key in TPM..." >&2
create_tpm2_key --rsa -p 81000001 /host/certs/edge_tls.key

echo "Creating cert with tpm key..." >&2
DEVICE_ID="XXX4242424242"
OPENSSL_CONF=openssl_tpm2.cnf openssl req -keyform engine -engine tpm2 -key /host/certs/edge_tls.key -new -x509 -days 365 -subj "/CN=$DEVICE_ID/OU=$K8S_NODE_NAME" -out /host/certs/edge_tls.crt
