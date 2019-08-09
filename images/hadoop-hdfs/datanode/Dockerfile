ARG repository
ARG image_version
FROM $repository/base:$image_version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides Cloudera Hadoop DFS DataNode $image_version"


RUN yum update -y \
&&  yum install -y hadoop-hdfs-datanode \
&&  yum clean all


COPY entrypoint  /etc/docker/entrypoint


EXPOSE 50075/tcp
EXPOSE 50010/tcp
EXPOSE 50020/tcp
EXPOSE 1004/tcp
EXPOSE 1006/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
