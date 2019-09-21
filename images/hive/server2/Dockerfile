ARG repository
ARG image_version
FROM $repository/base:$image_version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides Apache Hive Server2 on Cloudera Hadoop $image_version"


RUN yum update -y \
&&  yum install -y hive-server2 \
&&  yum clean all

COPY hiveserver2-site.xml.j2    /etc/hive/conf/hiveserver2-site.xml.j2
COPY beeline-site.env.j2        /etc/hive/conf/beeline-site.env.j2
COPY entrypoint                 /etc/docker/entrypoint


EXPOSE 10000/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
