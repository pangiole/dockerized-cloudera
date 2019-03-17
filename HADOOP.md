# Hadoop 2.6
This wiki page tells you how to install Hadoop 2.6 client programs on host (for example onto your **macOS** laptop) and make them communicate with services running in the _"dockerized"_ Cloudera CDH5 cluster.

## Install
Execute the `install` script to automatically download and extract the Hadoop Client 2.6 software distribution for your laptop:

```bash
./install
```

## Configure
Right after you started the dockerized Cloudera cluster, you can configure your local Hadoop Client 2.6 software as follows:

```bash
./start
./configure
```

### ~/.bash_profile
Reload your Bash profile and double check your environment.

```bash
source ~/.bash_profile
env | grep HADOOP
```

### /etc/krb5.conf
Update your Kerberos configuration

```bash
sudo mv /Library/Preferences/edu.mit.Kerberos /Library/Preferences/edu.mit.Kerberos.backup
sudo mv /etc/krb5.conf /etc/krb5.conf.backup
```


### /etc/hosts
Update your `hosts` file.

```bash
sudo cat <<CAT >> /etc/hosts

#
# Dockerized Cloudera CDH5 cluster
#
127.0.0.1    kdc.docker.net
127.0.0.1    namenode.docker.net
127.0.0.1    datanode1.docker.net
127.0.0.1    jobhistory.docker.net
127.0.0.1    resourcemanager.docker.net
127.0.0.1    nodemanager1.docker.net
CAT
```


## Use


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

## Native Libraries
This section is optional.

You may need Hadoop 2.6 native libraries properly built and installed onto your system.

```bash
hadoop checknative -a
```

### macOS
Using Homebrew, install macOS native compilers, Java tools and 3rd party libraries

```bash
brew install \
     cmake openssl zlib \
     protobuf@2.5 snappy maven

brew link --force protobuf@2.5
```

Git clone the [apache/hadoop](https://github.com/apache/hadoop) source code repository, checkout the right release branch and apply a small patch:

```bash
git clone https://github.com/apache/hadoop.git
cd hadoop
git checkout branch-2.6.0
git apply $CDH5_HOME/hadoop-2.6.0.patch
```

Make sure that, from the [Oracle website](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase7-521261.html), you got a Java SDK 1.7.0 installed and configured as follows:

```bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home"
sudo ln -snf lib $JAVA_HOME/Classes
sudo ln -snf tools.jar $JAVA_HOME/Classes/classes.jar
```


Then kick-off the Maven build as follows:

```bash
mvn clean package \
  -Pdist,native -Dtar \
  -DskipTests -Dmaven.javadoc.skip=true \
  -Dhttps.protocols=TLSv1.2
```

Copy the native libraries over:

```bash
cp -rp \
  ./hadoop-dist/target/hadoop-2.6.0/lib/native \
  $HADOOP_HOME/lib/native
```

and finally edit your shell profile:

```bash
cat <<CAT >> ~/.bash_profile
export HADOOP_OPTS="-D$HADOOP_HOME/lib/native $HADOOP_OPTS"
CAT
```
