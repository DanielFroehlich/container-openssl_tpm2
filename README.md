# container-openssl_tpm2
Container Image with openssl and IBM TSS TPM2 engine and tools

See:
https://git.kernel.org/pub/scm/linux/kernel/git/jejb/openssl_tpm2_engine.git/about/


Create service account and grant scc privileged:
```
oc create serviceaccount privileged-tpmaccess  
oc adm policy add-scc-to-user privileged -z privileged-tpmaccess --as system:admin
```
