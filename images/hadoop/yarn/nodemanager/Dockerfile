ARG repository
ARG version
FROM $repository/base:$version


LABEL maintainer="pangiolet@tibco.com"
LABEL description="This image provides Cloudera Hadoop YARN NodeManager $version"


RUN yum update -y && \
    yum install -y hadoop-yarn-nodemanager \
    yum clean all


COPY container-executor.cfg    /etc/hadoop/conf/container-executor.cfg


EXPOSE 8042/tcp


COPY entrypoint  /etc/docker/entrypoint
ENTRYPOINT ["/etc/docker/entrypoint"]
