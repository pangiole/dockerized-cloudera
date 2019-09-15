# Cloudera Hadoop
A "dockerized" Cloudera Hadoop cluster to ease development and test of BigData applications

> WARN  
> This project is *not* meant for production use!
>

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

## Start
You can start the Cloudera Hadoop cluster either with `simple` authentication (default) or with `kerberos`.

```bash
$ ./start \
  --version 5.16.1 \
  --kerberos
```

The only versions available so far are:

- 5.4.2
- 5.16.1
- 6.2.0


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


### Shared resources
Services of this cluster are sharing both the Hadoop configuration and the Kerberos secrets via a named Docker volume. The `shared` volume is mounted within each of the containers at the `/shared` mount point.

```
/
├── shared/
│   ├── conf/
│   │   ├── beeline-site.xml
│   │   ├── core-site.xml
│   │   ├── hdfs-site.xml
│   │   ├── hive-site.xml
│   │   ├── mapred-site.xml
│   │   └── yarn-site.xml
│   ├── secrets/
│   │   ├── alice.keytab
│   │   ├── charlie.keytab
│   │   ├── hdfs.keytab
│   │   ├── rootca.jks
│   │   ├── yarn.keytab
...
```


## Clients
This Cloudera Docker cluster supports any client program built with Hadoop libraries matching the server-side ones. Examples are: the command line `hadoop` tool, the Hive `beeline` tool, the Apache `spark-submit` tool and the Alpine/Chorus systems.

### in containers
If you wish to run Hadoop client binaries inside a Docker container the refer to the [red/hadoop-client](https://gitlab.alpinedata.tech/red/hadoop-client) project.

### on host
If you wish to run Hadoop client binaries on host (for example on your macOS laptop) then read the [client/HADOOP.md](./client/HADOOP.md) file for further information.


### Networking
All of the containers belonging to the Cloudera Hadoop cluster will join the same Docker network named `docker.net`

Docker port forwarding will allow applications/services running on host to communicate with the dockerized services running in the cluster as long as you update your `/etc/hosts` file as follows

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
docker image ls | grep cdh5
docker image inspect red/cdh5/base:5.16.1
```

You can even destroy what you just built:

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
