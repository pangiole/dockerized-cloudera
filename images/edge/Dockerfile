ARG repository
ARG version
FROM $repository/base:$version

LABEL maintainer="pangiolet@tibco.com"
LABEL description="This image provides an egde node for Cloudera Hadoop $version"

# TODO add more Spark versions here ...
ENV SPARK_VERSIONS="2.1.2"
ENV SPARK_HOME="/opt/spark"
ENV HADOOP_VERSIONS="2.6"
ENV HADOOP_CONF_DIR="/etc/hadoop/conf"
ENV YARN_CONF_DIR="/etc/hadoop/conf"
ENV PATH="/opt/spark/bin:$PATH"


RUN yum update -y \
&&  yum install -y hive \
&&  mkdir -p /opt && cd $_ \
&&  for hadoop_version in ${HADOOP_VERSIONS}; do for spark_version in $SPARK_VERSIONS; do curl -s -L http://repos/spark/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz | tar xvfz - ; ln -snf spark-${spark_version}-bin-hadoop${hadoop_version} spark ; done ; done


COPY titanic.csv       /var/data/raw/titanic.csv
COPY entrypoint        /etc/docker/entrypoint


ENTRYPOINT ["/etc/docker/entrypoint"]
