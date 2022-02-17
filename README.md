Container Image with openssl and IBM TSS TPM2 engine and tools to demo how to store mTLS keys in tpm device at the edge.


For IBM TSS TPM2 see:
https://git.kernel.org/pub/scm/linux/kernel/git/jejb/openssl_tpm2_engine.git/about/


Create service account and grant scc privileged:
```
oc create serviceaccount privileged-tpmaccess  
oc adm policy add-scc-to-user privileged -z privileged-tpmaccess --as system:admin
```

Verify Server Cert from laptop:
```
openssl s_client -showcerts -servername  openssl-server-dfroehli-tpm.apps.ocp1.stormshift.coe.muc.redhat.com -connect openssl-server-dfroehli-tpm.apps.ocp1.stormshift.coe.muc.redhat.com:443
```

Check public key of tpm:
```
tpm2_readpublic -c 0x81000001
```
