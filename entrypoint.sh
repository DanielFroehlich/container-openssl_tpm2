#!/bin/bash
while ! test -f "/host/certs/edge_tls.key"; do
  echo "No tls key found on hostpath. Please oc rsh into this pod and run /home/provision.sh script to generate one."
  sleep 10
done

if [[ ( $1 == "serve") ]]
then
  echo "Starting openssl server using cert with key in tpm on port 8443"
  cd /home
  OPENSSL_CONF=openssl_tpm2.cnf openssl s_server -cert /host/certs/edge_tls.crt -www -accept 8443 -keyform engine -engine tpm2 -key /host/certs/edge_tls.key
fi
