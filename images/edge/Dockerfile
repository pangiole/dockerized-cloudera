ARG repository
ARG version
FROM $repository/base:$version

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides an egde node for Cloudera Hadoop $version"

# TODO add more Spark versions here ...
# ENV SPARK_VERSIONS="2.4.3"
# ENV HADOOP_VERSIONS="2.7"

RUN yum update -y \
&&  yum install -y \
        hive-server2 \
        openssh-server \
        openssh-clients \
&&  mkdir -p /opt && cd $_
# &&  for hadoop_version in ${HADOOP_VERSIONS}; do for spark_version in $SPARK_VERSIONS; do curl -s -L http://repos/spark/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz | tar xvfz - ; ln -snf spark-${spark_version}-bin-hadoop${hadoop_version} spark ; done ; done


COPY titanic.csv       /etc/docker/titanic.csv
COPY biostats.csv      /etc/docker/biostats.csv
COPY create.hql        /etc/docker/create.hql
COPY entrypoint        /etc/docker/entrypoint
COPY bash_profile.j2   /etc/docker/bash_profile.j2


ENTRYPOINT ["/etc/docker/entrypoint"]
