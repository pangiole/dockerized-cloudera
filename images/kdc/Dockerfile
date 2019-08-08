ARG repository
ARG version
FROM $repository/base:$version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides the MIT Kerberos KDC for Clouder Hadoop $version"

RUN yum update -y \
&&  yum install -y \
        krb5-server \
        krb5-libs \
        krb5-auth-dialog \
        krb5-workstation \
&&  yum clean all


COPY kdc.conf    /var/kerberos/krb5kdc/kdc.conf
COPY kadm5.acl   /var/kerberos/krb5kdc/kadm5.acl
COPY init        /etc/docker/init
COPY entrypoint  /etc/docker/entrypoint


EXPOSE 4088/tcp
EXPOSE 4088/udp


ENTRYPOINT ["/etc/docker/entrypoint"]
