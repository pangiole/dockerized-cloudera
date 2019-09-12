# Hive JDBC URL
TBD

## Simple
When connecting to HiveServer2 with simple authentication, the URL format is:

```sh
url="jdbc:hive2://$host:$port/$db"
```


## Kerberos
When connecting to HiveServer2 with Kerberos authentication, the URL format is:

```sh
url="jdbc:hive2://$host:$port/$db;principal=$principal"
```

### principal
The principal is the Hive2 service principal as configured in the /`etc/hive/conf/hive-site.xml` file via the `hive.server2.authentication.kerberos.principal` configuration property.

Usually, the Hive2 service principal is made of 2 components separated by the slash character, as in `hive/docker.net` followed by the Kerberos realm, for example `DOCKER.NET`. Very often, the first component corresponds to the Linux user that runs the Hive2 server process, such as `hive`, while the second component corresponds to the hostname (or the domain name) such as `docker.net`.

### proxyUser

```sh
url="$url;hive.server2.proxy.user=$proxyUser"
```

### example
Here it follows a complete example:

```sh
host="hive.docker.net"
port="10000"
db="default"
principal="hive/docker.net@DOCKER.NET"
proxyUser="charlie"

url="jdbc:hive2://$host:$port/$db;principal=$principal;hive.server2.proxy.user=$proxyUser"

```

### TGT
Before attempting the JDBC connection, either using the `beeline` program or programmatically via the JDBC API), the user must acquire a valid Kerberos TGT - Ticket Granting Ticket.

The ticket can be acquired by any other means, for example using the `kinit` program or programmatically via the Hadoop client API.
