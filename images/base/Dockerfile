FROM centos:6.10

LABEL maintainer="pangiolet@tibco.com"
LABEL description="This image provides the base software for Cloudera Hadoop"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ENV CENTOS_VERSION=6.10
COPY centos-6.10.repo  /etc/yum.repos.d/centos-6.10.repo
RUN rm -f /etc/yum.repos.d/CentOS-* \
&&  yum update -y \
&&  yum install -y \
        initscripts \
        ntp \
        python-jinja2 \
        krb5-libs \
        krb5-workstation \
        vim zip \
&&  yum clean all \
&&  chkconfig iptables off \
&&  echo -e "root" | passwd root --stdin

COPY krb5.conf  /etc/krb5.conf
COPY render     /etc/docker/render
COPY idle       /etc/docker/idle


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ARG version
ENV cloudera_version=${version}
COPY cdh-${version}.repo  /etc/yum.repos.d/cdh-${version}.repo
RUN yum update -y \
&&  yum install -y \
        http://repos/oracle/jdk.rpm \
        hadoop-client \
&&  yum clean all \
&&  for user in alice bob spark; do useradd --create-home --gid hadoop $user; echo -e "$user" | passwd $user --stdin; done \
&&  cp -rp /etc/hadoop/conf.empty /etc/hadoop/conf.dockerized \
&&  alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.dockerized 50 \
&&  alternatives --set hadoop-conf /etc/hadoop/conf.dockerized \
&&  echo export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))" > /etc/profile.d/javaenv.sh \
&&  chmod 0755 /etc/profile.d/javaenv.sh \
&&  source /etc/profile.d/javaenv.sh \
&&  echo "crypto.policy=unlimited" >> $JAVA_HOME/lib/security/java.security


COPY core-site.xml.j2       /etc/hadoop/conf/core-site.xml.j2
COPY hdfs-site.xml.j2       /etc/hadoop/conf/hdfs-site.xml.j2
COPY yarn-site.xml.j2       /etc/hadoop/conf/yarn-site.xml.j2
COPY mapred-site.xml.j2     /etc/hadoop/conf/mapred-site.xml.j2
COPY bash_profile.j2        /etc/docker/bash_profile.j2
COPY setup                  /etc/docker/setup


# TODO Shouldn't we place different hdfs-site.xml settings? One for each of the containers?
