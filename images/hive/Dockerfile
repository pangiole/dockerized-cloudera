ARG repository
ARG image_version
FROM $repository/base:$image_version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides Apache Hive2 on Cloudera Hadoop $image_version"


RUN yum update -y \
&&  yum install -y hive-server2 \
&&  yum clean all


COPY entrypoint        /etc/docker/entrypoint


EXPOSE 10000/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
