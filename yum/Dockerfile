FROM centos:6.10
LABEL maintainer="pangiole@tibco.com"
LABEL description="This image provides YUM: the Red Hat package manager \
and additional tools to create local repositories"

RUN yum update -y && \
    yum install -y \
        yum-utils \
        createrepo \
        curl
