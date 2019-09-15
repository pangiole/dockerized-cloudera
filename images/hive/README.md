# Hive JDBC URL
TBD

## Simple
When connecting to HiveServer2 with simple authentication, the URL format is:

```sh
url="jdbc:hive2://$host:$port/$db"
```


## Kerberos
When connecting to HiveServer2 with Kerberos authentication, the JDBC URL requires additional parameters as follows:

```sh
url="$url;auth=kerberos;principal=$principal"
```

### principal
The principal is the Hive2 service principal as configured in the /`etc/hive/conf/hive-site.xml` file via the `hive.server2.authentication.kerberos.principal` configuration property.

Usually, the Hive2 service principal is made of 2 components separated by the slash character, as in `hive/docker.net` followed by the Kerberos realm, for example `DOCKER.NET`. Very often, the first component corresponds to the Linux user that runs the Hive2 server process, such as `hive`, while the second component corresponds to the hostname (or the domain name) such as `docker.net`.

## TGT
Before attempting _"kerberized"_ JDBC connections, either using the `beeline` program or programmatically via the JDBC API, the user must acquire a valid Kerberos TGT - Ticket Granting Ticket.

### impersonation

* `alice`   
   She is the **real** user who logs in the Kerberos system and acquires the Kerberos TGT. She is the impersonator who impersonates anyone else.

* `bob` | `charlie` | `david`  
   They are the **impersonatee** users who get impersonated by the real one. They are the subject of impersonation. They are also known as **proxy** users.

### interactive
The Kerberos TGT can be acquired using the `kinit` program as follows:

```sh

kinit -k -t /shared/secrets/alice.keytab alice@DOCKER.NET
```

The JDBC URL allows an additional parameter as follows:

```sh
url="$url;hive.server2.proxy.user=$proxyUser"
```


### programmatically

```scala

// Obtain the Kerberos TGT first as the realUser
val impersonator = "alice"
val principal    = s"$impersonatorr@DOCKER.NET"
val keytab       = s"/shared/secrets/$impersonator.keytab"
val realUser     =
  UserGroupInformation.loginUserFromKeytabAndReturnUGI(principal, keytab)

// Make the proxyUser
val impersonatee = "charlie"
val proxyUser    =
  UserGroupInformation.createProxyUser(impersonatee, realUser)

// Finally connect
val conn =
  proxyUser.doAs(action{
    driver.connect()
  })  
```
