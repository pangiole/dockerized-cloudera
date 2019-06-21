# Hadoop Client
This wiki page tells you how to install Hadoop client binaries on host (for example onto your **macOS** laptop) and make them communicate with services running in the _"dockerized"_ Cloudera CDH5 cluster.


## Install
Execute the `install` script to automatically download and extract the desired Hadoop client binary distribution for your laptop in 2 simple steps:

1. Download and extract Hadoop client binaries
    ```
    $ ./client/install 2.6.0
    ```
    
2. Update your local `~/.bash_profile`
    ```
    $ cat <<CAT >> ~/.bash_profile
    export HADOOP_HOME=$HOME/hadoop-2.6.0
    export HADOOP_CONF_DIR=$HOME/hadoop-2.6.0/etc/hadoop

    CAT
    ```

## Configure
Right after you started the dockerized Cloudera cluster, you can configure your local Hadoop Client 2.6 software in few simple steps:

1. Start the Docker Cloudera cluster
    ```
    $ ./start
    ```
    It takes a few seconds for the cluster to reach the ready state and finally generate the `.cloudera` directory. That's where the whole configuration is exposed.

2. Configure your Hadoop client binaries
    ```
    $ ./client/configure /path/to/.cloudera
    ```
    
3.  Update your Kerberos configuration
    ```
    $ sudo mv /Library/Preferences/edu.mit.Kerberos /Library/Preferences/edu.mit.Kerberos.backup
    $ sudo mv /etc/krb5.conf /etc/krb5.conf.backup
    ```

4. Update your `/etc/hosts` file (if not done yet)
    ```
    $ sudo cat <<CAT >> /etc/hosts
    
    #
    # Dockerized Cloudera CDH5 cluster
    #
    127.0.0.1    kdc.docker.net
    127.0.0.1    namenode.docker.net
    127.0.0.1    datanode1.docker.net
    127.0.0.1    jobhistory.docker.net
    127.0.0.1    resourcemanager.docker.net
    127.0.0.1    nodemanager1.docker.net
    127.0.0.1    hive.docker.net
    CAT
    ```


## Use
You can finally use the Hadoop client binaries.

### Authenticate
Acquire your Kerberos TGT - Ticket Granting Ticket.

```bash
kinit -k -t $HADOOP_CONF_DIR/hdfs.keytab hdfs/docker.net
klist -v
```


### Browse

```bash
hadoop fs -ls /data/raw
hadoop fs -copyFromLocal  -f /path/to/whatever.csv /data/raw
```

## Hadoop native libs
This section is optional.

You may need Hadoop native libraries properly built and installed onto your system.

```bash
hadoop checknative -a
```

### macOS
Using Homebrew, install macOS native compilers, Java tools and 3rd party libraries

```
$ brew install \
       cmake openssl zlib \
       protobuf@2.5 snappy maven

$ brew link --force protobuf@2.5
$ brew link --force openssl
```


### Hadoop 2.6.0
Git clone the [apache/hadoop](https://github.com/apache/hadoop) source code repository, checkout the right release branch and apply a small patch:

```bash
$ mkdir tmp && cd $_
$ git clone https://github.com/apache/hadoop.git
$ cd hadoop

$ git checkout branch-2.6.0
$ git apply ../../hadoop-2.6.0.patch
```

Make sure that, from the [Oracle website](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase7-521261.html), you got a Java SDK 1.7.0 installed and configured as follows:

```bash
$ export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home"
$ sudo ln -snf lib $JAVA_HOME/Classes
$ sudo ln -snf tools.jar $JAVA_HOME/Classes/classes.jar
```


Then kick-off the Maven build as follows:

```bash
$ mvn clean package \
      -Pdist,native -Dtar \
      -Dopenssl.prefix=/usr/local/Cellar/openssl/1.0.2s \
      -DskipTests -Dmaven.javadoc.skip=true \
      -Dhttps.protocols=TLSv1.2
```

Copy the native libraries over:

```bash
$ cp -rp \
      ./hadoop-dist/target/hadoop-2.6.0/lib/native \
      $HADOOP_HOME/lib
```


### Hadoop 3.2.0

Git clone the [apache/hadoop](https://github.com/apache/hadoop) source code repository, checkout the right release:

```
$ mkdir tmp && cd $_
$ git clone https://github.com/apache/hadoop.git
$ cd hadoop

$ git checkout branch-3.2.0
```

Then kick-off the Maven build as follows:

```bash
$ mvn clean package \
      -Pdist,native -Dtar \
      -DskipTests -Dmaven.javadoc.skip=true \
      -Dhttps.protocols=TLSv1.2
```

Copy the native libraries over:

```bash
$ cp -rp \
      ./hadoop-dist/target/hadoop-3.2.0/lib/native \
      $HADOOP_HOME/lib
```