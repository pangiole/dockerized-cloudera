# Cloudera Hadoop
This project gives you an easy way to build and start a local Cloudera Hadoop cluster whose services are running within Docker containers on localhost.

> WARN  
> This project is meant to facilitate software development and testing of BigData application.
>
> It is *not* meant for production use!


The Docker images built with this project will provide you with:

- Linux CentOS 6.10
  - MIT Kerberos 5-1.10.3
  - Cloudera Hadoop
      * HDFS NameNode
      * HDFS DataNode
      * MapRed JobHistory
      * YARN ResourceManager
      * YARN NodeManager
  - **no** Cloudera Manager
  - **no** Cloudera Parcels

## Requirements
All you is need Docker Desktop to be installed as per [official documentation](https://www.docker.com/products/docker-desktop).

## Login
The provided `./start` script will make your Docker host pull down images from our private GitLab Docker Registry. Make sure you can login as follows:

```bash
$ docker login \
    registry.alpinedata.tech \
    --username <username> \
    --password-stdin
```

More information are given in the official [GitLab documentation](https://docs.gitlab.com/ee/user/project/container_registry.html)

## Start
You can start the Cloudera Hadoop cluster for a given version and mount directory, either with `simple` authentication (default) or with `kerberos`.

```bash
$ ./start \
  --version 5.16.1 \
  --mount /path/to/mount \
  --kerberos
```

The only versions available are:

- 5.4.2
- 5.16.1

The mount directory is where mount secrets (such as keytab files) and configuration files (such as `core-site.xml`) will be targeted to.

The `start` script does no more than invoking `docker-compose` with the following environment variables.

```
export registry="registry.alpinedata.tech"
export repository="red/cloudera"
export version="5.16.1"
export mount="/path/to/mount/cloudera"
export hadoop_auth="kerberos"
export sasl_protection="authentication"
export tls_encryption="false"
```

### Stop
You can stop the whole Cloudera Hadoop cluster as follows:

```bash
$ ./stop
```

## Containers
The dockerized Cloudera Hadoop cluster is composed of the following containers:

- **namenode**    
  It hosts the Hadoop HDFS NameNode server

- **datanode1**  
  It hosts the Hadoop HDFS DataNode server

- **jobhistory**  
  It hosts the Hadoop MapRed JobHistory server

- **resourcemanager**  
  It hosts the Hadoop YARN ResourceManager master server.

- **nodemanager1**  
  It hosts the Hadoop YARN NodeManager slave server.

- **hive**  
  It hosts the Apache Hive2 server running in embedded mode.

- **edge**  
  It does NOT host any server process but it does provide Hadoop, Hive and Spark command line clients (such as `spark-shell`, `beeline`, etc.)


### Login
You can execute `bash` within any of the above containers:

```
./login <container>
```


### Resources
Once the containers cluster is started, it will reveal its configuration by generating the following files to your local working directory:

```
├── $mount/cloudera
│   ├── conf
│   │   ├── core-site.xml
│   │   ├── hdfs-site.xml
│   │   ├── mapred-site.xml
│   │   ├── hive-site.xml
│   │   └── yarn-site.xml
│   ├── secrets
│   │   ├── alice.keytab
│   │   ├── hdfs.keytab
│   │   ├── rootca.jks
│   │   ├── yarn.keytab
...
```
Those XML configuration and Kerberos keytab files will make you able to configure your client applications correctly.


## Clients
This Cloudera Docker cluster supports any client program built with Hadoop libraries matching the server-side ones. Examples are: the command line `hadoop` tool, the Hive `beeline` tool, the Apache `spark-submit` tool and the Alpine/Chorus systems.

If you wish to run Hadoop client tools on host (for example on your macOS laptop) then read the [client/HADOOP.md](./client/HADOOP.md) file for further information.


### Networking
All of the containers belonging to the Cloudera Hadoop cluster will join the same Docker network named `docker.net`

Docker port forwarding will allow applications/services running on your Docker host to communicate with the dockerized services running in the cluster as long as you update your `/etc/hosts` file as follows

```
# Cloudera Docker
#
127.0.0.1    kdc.docker.net
127.0.0.1    namenode.docker.net
127.0.0.1    resourcemanager.docker.net
127.0.0.1    jobhistory.docker.net
127.0.0.1    datanode1.docker.net
127.0.0.1    nodemanager1.docker.net
127.0.0.1    hive.docker.net
127.0.0.1    edge.docker.net
```


## Build
You can build new versions of Cloudera Hadoop images as explained below.

### YUM
As preliminary step, you need to build local mirrors of Linux RedHat YUM repositories. Set the desired version of Cloudera Hadoop and the path to the RPM Package of the Oracle JDK for Linux x64 as follows:

```bash
./yum/build \
  --version 5.16.1 \
  --jdk /path/to/jdk-8u201-linux-x64.rpm
```

Be patient as building YUM mirrors takes very long time to complete.

### Docker
After you got the YUM repositories, you can finally build the new Docker images as follows:

```bash
./images/build \
  --version 5.16.1
```

Once done, double check that all images have been built correctly by listing and inspecting them.

```bash
docker image ls | grep cloudera
docker image inspect cloudera/base:5.16.1
```

You can even destroy what you built:

```bash
./images/destroy \
  --version 5.16.1
```

## Push
You can push the new Docker images to our private Docker Registry as follows:

```bash
./images/push \
  --version 5.16.1
```
