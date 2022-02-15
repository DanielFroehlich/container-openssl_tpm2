FROM registry.access.redhat.com/ubi8/ubi

RUN curl https://download.opensuse.org/repositories/home:/jejb1:/TPM/Fedora_29/home:jejb1:TPM.repo -o /etc/yum.repos.d/tpm.repo \
&& yum -y install openssl ibmswtpm2 ibmtss openssl_tpm2_engine openssl-pkcs11-export \
&& yum clean all

ADD entrypoint.sh /
ADD openssl_tpm2.cnf /


EXPOSE 8443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
