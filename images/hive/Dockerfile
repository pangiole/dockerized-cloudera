ARG repository
ARG version
FROM $repository/base:$version

LABEL maintainer="pangiolet@tibco.com"
LABEL description="This image provides Apache Hive on Cloudera Hadoop $version"


RUN yum update -y \
&&  yum install -y hive hive-server2 \
&&  yum clean all


COPY hive-site.xml.j2  /etc/hadoop/conf/hive-site.xml.j2
COPY entrypoint        /etc/docker/entrypoint


EXPOSE 10000/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
