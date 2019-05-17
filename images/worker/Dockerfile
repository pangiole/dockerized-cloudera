ARG repository
ARG version
FROM $repository/base:$version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides Cloudera Hadoop DFS DataNode, YARN NodeManager $version"


RUN yum update -y \
&&  yum install -y \
        hadoop-hdfs-datanode \
        hadoop-yarn-nodemanager \
&&  yum clean all


COPY container-executor.cfg    /etc/hadoop/conf/container-executor.cfg
COPY entrypoint                /etc/docker/entrypoint

# Hadoop DFS DataNode
EXPOSE 50075/tcp
EXPOSE 50010/tcp
EXPOSE 50020/tcp
EXPOSE 1004/tcp
EXPOSE 1006/tcp

# Hadoop YARN NodeManager
EXPOSE 8042/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
