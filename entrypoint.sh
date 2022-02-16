#!/bin/bash

# ARG is either
# - provision to create new key and cert inside the tpm
# - serve to run an openssl server with key and cert created by provisioning

if [[ ( $1 == "provision") ]]
then
  # TODO:
  #Good practice is to generate the RSA version of the primary storage seed and place it at well known location 81000001 (Microsoft Spec).
  # TPM_DEVICE=/dev/tpm0 tsscreateprimary -hi o -st -rsa
  # Handle 80000000 (Use for next calls)
  # TPM_DEVICE=/dev/tpm0 tssevictcontrol -hi o -ho 80000000 -hp 81000001
  # TPM_DEVICE=/dev/tpm0 tssflushcontext -ha 80000000

  echo "Creating private key in TPM..." >&2
  create_tpm2_key --rsa -p 81000001 tls.key

  echo "Creating cert with tpm key..." >&2
  DEVICE_ID="XXX4242424242"
  OPENSSL_CONF=openssl_tpm2.cnf openssl req -keyform engine -engine tpm2 -key tls.key -new -x509 -days 365 -subj "/CN=$DEVICE_ID" -out tls.crt
  echo "Write k8s secret to stdout..." >&2
# TODO: Add Node Name to secret name
  cat <<EOF
kind: Secret
type: kubernetes.io/tls
apiVersion: v1
metadata:
  name: tls-tpm2
data:
  tls.crt: $(base64 -w 0 tls.crt)
  tls.key: $(base64 -w 0 tls.key)
EOF
  echo "...done!" >&2
fi

if [[ ( $1 == "serve") ]]
then
  echo "Starting openssl server using cert with key in tpm on port 8443"
  cd /home
  OPENSSL_CONF=openssl_tpm2.cnf openssl s_server -cert certs/tls.crt -www -accept 8443 -keyform engine -engine tpm2 -key certs/tls.key
fi
