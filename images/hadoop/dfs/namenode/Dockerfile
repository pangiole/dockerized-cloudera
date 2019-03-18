ARG repository
ARG version
FROM $repository/base:$version

LABEL maintainer="pangiolet@tibco.com"
LABEL description="This image provides Cloudera Hadoop DFS NameNode $version"


RUN yum update -y \
&&  yum install -y hadoop-hdfs-namenode \
&&  yum clean all


COPY entrypoint  /etc/docker/entrypoint


EXPOSE 8020/tcp
EXPOSE 50070/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
