Container Image with openssl and IBM TSS TPM2 engine and tools to demo how to store mTLS keys in tpm device at the edge.

The key is stored on the host node via a K8S hostPath volumeMount.

The container checks if the key/cert is available. if yes, openssl is started in server mode.

If the key/cert is not yet there, the container waits for its creation. To create it, oc rsh / termin into the pod and exeute /home/provsion.sh script. See that script.

The deployment.yaml uses a node selector for a node label "tpm=present", make sure to label your nodes accordingly!

The deployment.yaml uses a pod anti affinity to push several pods across different nodes if available.
A readinessProbe is also configured to ensure only pods with avail keys are getting requests.


For IBM TSS TPM2 see:
https://git.kernel.org/pub/scm/linux/kernel/git/jejb/openssl_tpm2_engine.git/about/
(Kudos to JEJB for this great work!)


Some helper commands:

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
tssreadpublic -opem tpm_pub.key -ho 81000001  
cat pub.key
```
