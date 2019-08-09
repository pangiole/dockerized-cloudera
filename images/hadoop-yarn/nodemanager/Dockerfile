ARG repository
ARG image_version
FROM $repository/base:$image_version


LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides Cloudera Hadoop YARN NodeManager $image_version"


RUN yum update -y && \
    yum install -y hadoop-yarn-nodemanager \
    yum clean all


COPY container-executor.cfg    /etc/hadoop/conf/container-executor.cfg


EXPOSE 8042/tcp


COPY entrypoint  /etc/docker/entrypoint
ENTRYPOINT ["/etc/docker/entrypoint"]
