# Hadoop Client
This wiki page tells you how to install Hadoop client binaries on host (for example onto your **macOS** laptop) and make them communicate with services running in the _"dockerized"_ Cloudera CDH5 cluster.


## Install
Execute the `install` script to automatically download and extract the desired Hadoop client binary distribution for your laptop in 2 simple steps:

1. Download and extract Hadoop client binaries
    ```
    $ ./client/install \
        --version 2.6.0
    ```

2. Update your local shell profile with the following lines

    ```
    # file: ~/.bash_profile
    # ...

    export HADOOP_HOME=$HOME/hadoop-2.6.0
    export HADOOP_CONF_DIR=$HOME/hadoop-2.6.0/etc/
    ```

## Configure
Right after you started the dockerized Cloudera cluster, you can configure your local Hadoop Client 2.6 software in few simple steps:

1. Tips when **macOS**  
   If you're on macOS, backup your local Kerberos configuration and disable your local KDC daemon.
   
    ```
    $ sudo mv /Library/Preferences/edu.mit.Kerberos /Library/Preferences/edu.mit.Kerberos.backup
    $ sudo mv /etc/krb5.conf /etc/krb5.conf.backup
    
    $ sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.Kerberos.kdc.plist
    ```
    
2. Start the Cloudera Hadoop cluster
    ```
    $ ./start \
        --version 5.16.1 \
        --mount /path/to/mount \
        --kerberos
    ```
    It takes a few seconds for the cluster to reach the ready state and finally generate the `$mount/cloudera` directory. That's where the whole configuration and secrets are targeted.


3. Configure your local Hadoop client binaries
    ```
    $ ./client/configure \
        --from /path/to/mount \
        --kerberos
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

```
$ kinit -k -t $HADOOP_CONF_DIR/hdfs.keytab hdfs/docker.net
$ klist -v
```


### Browse

```
$ hadoop fs -ls /data/raw
$ hadoop fs -copyFromLocal  -f /path/to/whatever.csv /data/raw
```

## Hadoop native libs
Although this section is fully optional it is strongly recommended. You may need Hadoop native libraries built and installed onto your macOS system.

```
$ hadoop checknative -a
```

### macOS
Using Homebrew, install macOS native compilers, Java tools and 3rd party libraries

```
$ brew install \
       autoconf automake bzip2 cmake \
       gcc gzip libtool maven openssl \
       snappy zlib

$ brew link --force openssl
```

#### OpenSSL

```
$ cd /usr/local/include
$ ln -s ../opt/openssl/include/openssl .
```

#### Protocol Buffer 2.5
HomeBrew has deprecated the protobuf@2.5 formulae. The best way to install it is as follows:

```
$ wget https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.bz2
$ tar xvf protobuf-2.5.0.tar.bz2
$ cd protobuf-2.5.0
$ ./configure CC=clang CXX=clang++ \
              CXXFLAGS='-std=c++11 -stdlib=libc++ -O3 -g' \
              LDFLAGS='-stdlib=libc++' LIBS="-lc++ -lc++abi"
$ make -j 4
$ sudo make install
$ protoc --version
```


### Hadoop 2.6.0
Git clone the [apache/hadoop](https://github.com/apache/hadoop) source code repository and checkout the right branch:

```
$ mkdir tmp && cd $_
$ git clone https://github.com/apache/hadoop.git
$ cd hadoop

$ git checkout branch-2.6.0
```

#### Apply a patch
Apply a small patch

```
$ git apply ../../hadoop-2.6.0.patch
```

#### Install Java SDK 1.7
Make sure that, from the [Oracle website](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase7-521261.html), you got a Java SDK 1.7.0 installed and configured as follows:

```
$ export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home"
$ sudo ln -snf lib $JAVA_HOME/Classes
$ sudo ln -snf tools.jar $JAVA_HOME/Classes/classes.jar
```

#### Build using Maven
Then kick-off the Maven build as follows:

```
$ OPENSSL_VERSION="1.0.2s"
$ mvn clean package \
      -Pdist,native -Dtar \
      -Dopenssl.prefix=/usr/local/Cellar/openssl/$OPENSSL_VERSION \
      -DskipTests -Dmaven.javadoc.skip=true \
      -Dhttps.protocols=TLSv1.2
```

#### Install libraries
Copy the native libraries over:

```
$ cp -rp \
      ./hadoop-dist/shared/hadoop-2.6.0/lib/native \
      $HADOOP_HOME/lib
```


### Hadoop latest
Git clone the [apache/hadoop](https://github.com/apache/hadoop) source code repository and checkout the right branch:

```
$ mkdir tmp && cd $_
$ git clone https://github.com/apache/hadoop.git
$ cd hadoop
```

#### Install Java SDK 1.8
Then [jEnv](https://www.jenv.be/) to easily switch JDK.


#### Build using Maven
Then kick-off the Maven build as follows:

```
$ mvn package \
      -Pdist,native -Dtar \
      -DskipTests -Dmaven.javadoc.skip=true \
      -Dhttps.protocols=TLSv1.2
```

#### Install libraries
Copy the native libraries over:

```
$ cp -rp \
      ./hadoop-dist/shared/hadoop-3.3.0-SNAPSHOT/lib/native \
      $HADOOP_HOME/lib
```
