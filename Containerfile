FROM registry.access.redhat.com/ubi8/ubi

RUN curl https://download.opensuse.org/repositories/home:/jejb1:/TPM/Fedora_29/home:jejb1:TPM.repo -o /etc/yum.repos.d/tpm.repo \
&& yum -y install openssl openssl_tpm2_engine openssl-pkcs11-export \
&& yum clean all

ADD entrypoint.sh /home
ADD provision.sh /home
ADD openssl_tpm2.cnf /home

EXPOSE 8443
ENTRYPOINT ["/home/entrypoint.sh"]
CMD ["serve"]
