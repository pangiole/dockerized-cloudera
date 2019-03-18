ARG repository
ARG version
FROM $repository/base:$version

LABEL maintainer="pangiolet@tibco.com"
LABEL description="This image provides Cloudera Hadoop JobHistory $version"


RUN yum update -y \
&&  yum install -y hadoop-mapreduce-historyserver \
&&  yum clean all


COPY entrypoint  /etc/docker/entrypoint


EXPOSE 19888/tcp
EXPOSE 10020/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
