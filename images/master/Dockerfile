ARG repository
ARG version
FROM $repository/base:$version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides Cloudera Hadoop DFS NameNode, JobHistory and YARN ResourceManager $version"


RUN yum update -y \
&&  yum install -y \
        hadoop-hdfs-namenode \
        hadoop-mapreduce-historyserver \
        hadoop-yarn-resourcemanager \
&&  yum clean all


COPY entrypoint  /etc/docker/entrypoint


# Hadoop DFS NameNode
EXPOSE 8020/tcp
EXPOSE 50070/tcp

# Hadoop JobHistory
EXPOSE 19888/tcp
EXPOSE 10020/tcp

# Hadoop YARN ResourceManager
EXPOSE 8088/tcp
EXPOSE 8032/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
