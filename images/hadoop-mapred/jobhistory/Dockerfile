ARG repository
ARG image_version
FROM $repository/base:$image_version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides Cloudera Hadoop JobHistory $image_version"


RUN yum update -y \
&&  yum install -y hadoop-mapreduce-historyserver \
&&  yum clean all


COPY entrypoint  /etc/docker/entrypoint


EXPOSE 19888/tcp
EXPOSE 10020/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
