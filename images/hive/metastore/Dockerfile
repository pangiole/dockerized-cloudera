ARG repository
ARG image_version
FROM $repository/base:$image_version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides Apache Hive Metastore on Cloudera Hadoop $image_version"

ENV HIVE_CONF_DIR=/etc/hive/conf

RUN yum update -y \
&&  yum install -y hive-metastore \
&&  yum clean all

COPY mysql-connector-java-8.0.17.jar /usr/lib/hive/lib/mysql-connector-java-8.0.17.jar
COPY hivemetastore-site.xml.j2       /etc/hive/conf/hivemetastore-site.xml.j2
COPY entrypoint                      /etc/docker/entrypoint


# ??? EXPOSE 10000/tcp


ENTRYPOINT ["/etc/docker/entrypoint"]
