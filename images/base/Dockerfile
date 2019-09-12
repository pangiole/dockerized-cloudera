FROM centos:6.10

LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides the base software for Cloudera Hadoop"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Linux CentOS setup
#
ENV  CENTOS_VERSION="6.10"

COPY centos-6.10.repo  /etc/yum.repos.d/centos-6.10.repo
COPY render            /etc/docker/render
COPY idle              /etc/docker/idle

RUN  rm -f /etc/yum.repos.d/CentOS-* \
&&   yum update -y \
&&   yum install -y \
         initscripts \
         lsof \
         nano \
         ntp \
         python-jinja2 \
         vim  \
         unzip \
         zip \
&&   chkconfig iptables off \
&&   echo -e "root" | passwd root --stdin



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Kerberos setup
#

COPY krb5.conf        /etc/krb5.conf
COPY bash_profile.j2  /etc/docker/bash_profile.j2
COPY setup            /etc/docker/setup

RUN  yum install -y \
         krb5-libs \
         krb5-workstation


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Oracle JDK setup
#
ENV JAVA_HOME="/usr/java/jdk1.8.0_201-amd64"

RUN yum install -y \
        http://repos/oracle/jdk-8.rpm \
&&  echo "crypto.policy=unlimited" >> $JAVA_HOME/jre/lib/security/java.security \
&&  cp $JAVA_HOME/jre/lib/security/cacerts $JAVA_HOME/jre/lib/security/jssecacerts


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TLS/SSL setup
#
COPY mkcerts /etc/docker/mkcerts
RUN  chmod +x /etc/docker/mkcerts \
&&   /etc/docker/mkcerts --rootca --outdir $JAVA_HOME/jre/lib/security


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Cludera Hadoop setup
#
ARG  cdh5_version
ENV  CDH5_VERSION=${cdh5_version}

COPY cdh-${cdh5_version}.repo  /etc/yum.repos.d/cdh-${cdh5_version}.repo

RUN  yum update -y \
&&   yum install -y hadoop-client \
&&   for user in alice bob; do useradd --create-home --gid hadoop $user; echo -e "$user" | passwd $user --stdin; done \
&&   for user in charlie david; do useradd --create-home --gid users $user; echo -e "$user" | passwd $user --stdin; done \
&&   cp -rp /etc/hadoop/conf.empty /etc/hadoop/conf.dockerized \
&&   alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.dockerized 50 \
&&   alternatives --set hadoop-conf /etc/hadoop/conf.dockerized

COPY core-site.xml.j2    /etc/hadoop/conf/core-site.xml.j2
COPY hdfs-site.xml.j2    /etc/hadoop/conf/hdfs-site.xml.j2
COPY yarn-site.xml.j2    /etc/hadoop/conf/yarn-site.xml.j2
COPY mapred-site.xml.j2  /etc/hadoop/conf/mapred-site.xml.j2
COPY hive-site.xml.j2    /etc/hive/conf/hive-site.xml.j2
COPY beeline-site.xml.j2 /etc/hive/conf/beeline-site.xml.j2
COPY beeline-site.env.j2 /etc/hive/conf/beeline-site.env.j2

RUN  yum clean all
