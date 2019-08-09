ARG repository
ARG image_version
FROM $repository/base:$image_version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides Cloudera Hadoop DFS NameNode $image_version"


RUN yum update -y \
&&  yum install -y hadoop-hdfs-namenode \
&&  yum clean all


COPY entrypoint  /etc/docker/entrypoint


EXPOSE 8020/tcp
EXPOSE 50070/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
