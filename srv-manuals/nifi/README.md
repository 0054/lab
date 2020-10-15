# NIFI

## мониторинг праймори ноды 


работает на питоне 2, но должно и на 3 (не тестил)
```
#!/usr/bin/env python

import sys
import json
import urllib2
import platform

hostname = platform.node().split('.')[0]
addr = "http://{}:8888/nifi-api/controller/cluster".format(hostname)

def getData(url):
    return json.loads(urllib2.urlopen(addr).read())

def isPrimary(data):
    for node in data['cluster']['nodes']:
        if node['address'] == hostname:
            if node['roles'] and 'Primary Node' in node['roles']:
                print hostname + ' is Primary Node'
                sys.exit(0)
            else:
                print hostname + ' is Slave Node'
                sys.exit(1)

if __name__ == '__main__':
    isPrimary(getData(addr))
```
## конфиг для keepalived например

```
vrrp_script chk_nifi {
  script        "/path/to/script/check_primary_nifi_node.py"
  interval 2   # check every 2 seconds
  fall 2       # require 2 failures for KO
  rise 2       # require 2 successes for OK
}

vrrp_instance VRRP2 {
    interface ens192
    virtual_router_id 43
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 7vynr349qy
    }
    virtual_ipaddress {
        1.2.3.4/24
    }
    track_script {
        chk_nifi
    }
}

```


## Настройка HTTPS + LDAPS

в этом примере настройка производится с помощью nifi-toolkit tsl-toolkit.sh и самоподписанного сертификата
[загружаем](https://nifi.apache.org/download.html) и распаковываем  nifi-toolkit 
генерируем сертификаты 
```
./nifi-toolkit-1.11.4/bin/tls-toolkit.sh standalone -n 'nifi.local'
```
будет создана директория nifi.local её содержимое ( сертификаты и nifi.properties ) необходимо перенести в nifi/conf/ и заменить nifi.properties
пример конфига:
```
nifi.flow.configuration.file=./conf/flow.xml.gz
nifi.flow.configuration.archive.enabled=true
nifi.flow.configuration.archive.dir=./conf/archive/
nifi.flow.configuration.archive.max.time=30 days
nifi.flow.configuration.archive.max.storage=500 MB
nifi.flow.configuration.archive.max.count=
nifi.flowcontroller.autoResumeState=true
nifi.flowcontroller.graceful.shutdown.period=10 sec
nifi.flowservice.writedelay.interval=500 ms
nifi.administrative.yield.duration=30 sec
nifi.bored.yield.duration=10 millis
nifi.queue.backpressure.count=10000
nifi.queue.backpressure.size=1 GB

nifi.authorizer.configuration.file=./conf/authorizers.xml
nifi.login.identity.provider.configuration.file=./conf/login-identity-providers.xml
nifi.templates.directory=./conf/templates
nifi.ui.banner.text=
nifi.ui.autorefresh.interval=30 sec
nifi.nar.library.directory=./lib
nifi.nar.library.autoload.directory=./extensions
nifi.nar.working.directory=./work/nar/
nifi.documentation.working.directory=./work/docs/components

nifi.state.management.configuration.file=./conf/state-management.xml
nifi.state.management.provider.local=local-provider
nifi.state.management.provider.cluster=zk-provider
nifi.state.management.embedded.zookeeper.start=false
nifi.state.management.embedded.zookeeper.properties=./conf/zookeeper.properties


nifi.database.directory=./database_repository
nifi.h2.url.append=;LOCK_TIMEOUT=25000;WRITE_DELAY=0;AUTO_SERVER=FALSE

nifi.flowfile.repository.implementation=org.apache.nifi.controller.repository.WriteAheadFlowFileRepository
nifi.flowfile.repository.wal.implementation=org.apache.nifi.wali.SequentialAccessWriteAheadLog
nifi.flowfile.repository.directory=./flowfile_repository
nifi.flowfile.repository.partitions=256
nifi.flowfile.repository.checkpoint.interval=2 mins
nifi.flowfile.repository.always.sync=false
nifi.flowfile.repository.encryption.key.provider.implementation=
nifi.flowfile.repository.encryption.key.provider.location=
nifi.flowfile.repository.encryption.key.id=
nifi.flowfile.repository.encryption.key=

nifi.swap.manager.implementation=org.apache.nifi.controller.FileSystemSwapManager
nifi.queue.swap.threshold=20000
nifi.swap.in.period=5 sec
nifi.swap.in.threads=1
nifi.swap.out.period=5 sec
nifi.swap.out.threads=4

nifi.content.repository.implementation=org.apache.nifi.controller.repository.FileSystemRepository
nifi.content.claim.max.appendable.size=1 MB
nifi.content.claim.max.flow.files=100
nifi.content.repository.directory.default=./content_repository
nifi.content.repository.archive.max.retention.period=12 hours
nifi.content.repository.archive.max.usage.percentage=50%
nifi.content.repository.archive.enabled=true
nifi.content.repository.always.sync=false
nifi.content.viewer.url=../nifi-content-viewer/
nifi.content.repository.encryption.key.provider.implementation=
nifi.content.repository.encryption.key.provider.location=
nifi.content.repository.encryption.key.id=
nifi.content.repository.encryption.key=

nifi.provenance.repository.implementation=org.apache.nifi.provenance.WriteAheadProvenanceRepository
nifi.provenance.repository.debug.frequency=1_000_000
nifi.provenance.repository.encryption.key.provider.implementation=
nifi.provenance.repository.encryption.key.provider.location=
nifi.provenance.repository.encryption.key.id=
nifi.provenance.repository.encryption.key=

nifi.provenance.repository.directory.default=./provenance_repository                                                                                                                                                 
nifi.provenance.repository.max.storage.time=24 hours
nifi.provenance.repository.max.storage.size=1 GB
nifi.provenance.repository.rollover.time=30 secs
nifi.provenance.repository.rollover.size=100 MB
nifi.provenance.repository.query.threads=2
nifi.provenance.repository.index.threads=2
nifi.provenance.repository.compress.on.rollover=true
nifi.provenance.repository.always.sync=false
nifi.provenance.repository.indexed.fields=EventType, FlowFileUUID, Filename, ProcessorID, Relationship
nifi.provenance.repository.indexed.attributes=
nifi.provenance.repository.index.shard.size=500 MB
nifi.provenance.repository.max.attribute.length=65536
nifi.provenance.repository.concurrent.merge.threads=2


nifi.provenance.repository.buffer.size=100000

nifi.components.status.repository.implementation=org.apache.nifi.controller.status.history.VolatileComponentStatusRepository
nifi.components.status.repository.buffer.size=1440
nifi.components.status.snapshot.frequency=1 min

nifi.remote.input.host=nifi.local
nifi.remote.input.secure=true
nifi.remote.input.socket.port=10443
nifi.remote.input.http.enabled=true
nifi.remote.input.http.transaction.ttl=30 sec
nifi.remote.contents.cache.expiration=30 secs

nifi.web.war.directory=./lib
nifi.web.http.host=
nifi.web.http.port=
nifi.web.http.network.interface.default=
nifi.web.https.host=nifi.local
nifi.web.https.port=9443
nifi.web.https.network.interface.default=
nifi.web.jetty.working.directory=./work/jetty
nifi.web.jetty.threads=200
nifi.web.max.header.size=16 KB
nifi.web.proxy.context.path=
nifi.web.proxy.host=

nifi.sensitive.props.key=
nifi.sensitive.props.key.protected=
nifi.sensitive.props.algorithm=PBEWITHMD5AND256BITAES-CBC-OPENSSL
nifi.sensitive.props.provider=BC
nifi.sensitive.props.additional.keys=

nifi.security.keystore=./conf/keystore.jks
nifi.security.keystoreType=jks
nifi.security.keystorePasswd=6D+hb95Oinwz/22fTYRopu6nzTlFpJdbWyqqBxNzA5c
nifi.security.keyPasswd=6D+hb95Oinwz/22fTYRopu6nzTlFpJdbWyqqBxNzA5c
nifi.security.truststore=./conf/truststore.jks
nifi.security.truststoreType=jks
nifi.security.truststorePasswd=k/wjhF6nfO/lCci7YKmyKyUs2RzQsRAgN97bcU4steQ
nifi.security.user.authorizer=managed-authorizer
nifi.security.user.login.identity.provider=ldap-provider
nifi.security.ocsp.responder.url=
nifi.security.ocsp.responder.certificate=

nifi.security.user.oidc.discovery.url=
nifi.security.user.oidc.connect.timeout=5 secs
nifi.security.user.oidc.read.timeout=5 secs
nifi.security.user.oidc.client.id=
nifi.security.user.oidc.client.secret=
nifi.security.user.oidc.preferred.jwsalgorithm=
nifi.security.user.oidc.additional.scopes=
nifi.security.user.oidc.claim.identifying.user=

nifi.security.user.knox.url=
nifi.security.user.knox.publicKey=
nifi.security.user.knox.cookieName=hadoop-jwt
nifi.security.user.knox.audiences=

nifi.cluster.protocol.heartbeat.interval=5 sec
nifi.cluster.protocol.is.secure=true

nifi.cluster.is.node=false
nifi.cluster.node.address=nifi.local
nifi.cluster.node.protocol.port=11443
nifi.cluster.node.protocol.threads=10
nifi.cluster.node.protocol.max.threads=50
nifi.cluster.node.event.history.size=25
nifi.cluster.node.connection.timeout=5 sec
nifi.cluster.node.read.timeout=5 sec
nifi.cluster.node.max.concurrent.requests=100
nifi.cluster.firewall.file=
nifi.cluster.flow.election.max.wait.time=5 mins
nifi.cluster.flow.election.max.candidates=

nifi.cluster.load.balance.host=
nifi.cluster.load.balance.port=6342
nifi.cluster.load.balance.connections.per.node=4
nifi.cluster.load.balance.max.thread.count=8
nifi.cluster.load.balance.comms.timeout=30 sec

nifi.zookeeper.connect.string=
nifi.zookeeper.connect.timeout=3 secs
nifi.zookeeper.session.timeout=3 secs
nifi.zookeeper.root.node=/nifi

nifi.zookeeper.auth.type=
nifi.zookeeper.kerberos.removeHostFromPrincipal=
nifi.zookeeper.kerberos.removeRealmFromPrincipal=

nifi.kerberos.krb5.file=

nifi.kerberos.service.principal=
nifi.kerberos.service.keytab.location=

nifi.kerberos.spnego.principal=
nifi.kerberos.spnego.keytab.location=
nifi.kerberos.spnego.authentication.expiration=12 hours

nifi.variable.registry.properties=

nifi.analytics.predict.enabled=false
nifi.analytics.predict.interval=3 mins
nifi.analytics.query.interval=5 mins
nifi.analytics.connection.model.implementation=org.apache.nifi.controller.status.analytics.models.OrdinaryLeastSquares
nifi.analytics.connection.model.score.name=rSquared
nifi.analytics.connection.model.score.threshold=.90
```

Для настройки LDAPS в conf/nifi.properties
указываем параметр:
```
nifi.security.user.login.identity.provider=ldap-provider
```
затем идём в conf/login-identity-providers.xml
правим со своими параметрами:

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<loginIdentityProviders>
    <provider>
        <identifier>ldap-provider</identifier>
        <class>org.apache.nifi.ldap.LdapProvider</class>
        <property name="Authentication Strategy">LDAPS</property>

        <property name="Manager DN">CN=Administrator,CN=Users,DC=example,DC=local</property>
        <property name="Manager Password">1qaz@WSX</property>

        <property name="TLS - Keystore"></property>
        <property name="TLS - Keystore Password"></property>
        <property name="TLS - Keystore Type"></property>
        <property name="TLS - Truststore">./ldap.truststore</property>
        <property name="TLS - Truststore Password">changeit</property>
        <property name="TLS - Truststore Type">jks</property>
        <property name="TLS - Client Auth"></property>
        <property name="TLS - Protocol">TLSv1.2</property>
        <property name="TLS - Shutdown Gracefully"></property>                                                                                                                                                       
        
        <property name="Referral Strategy">FOLLOW</property>
        <property name="Connect Timeout">10 secs</property>
        <property name="Read Timeout">10 secs</property>

        <property name="Url">ldaps://ldap.server.com:636</property>
        <property name="User Search Base">CN=Users,DC=example,DC=local</property>
        <property name="User Search Filter">sAMAccountName={0}</property>

        <property name="Identity Strategy">USE_USERNAME</property>
        <property name="Authentication Expiration">12 hours</property>
    </provider>
</loginIdentityProviders>
```

Тк в моём примере использовался LDAPS серверер с недоверенным сертификатом то пришлось создать truststore и добавить туда этот серт
```
# импорт сертификата 
keytool -printcert -sslserver ldap.server.com:636 -rfc > ldap.cer
keytool -import -v -trustcacerts -alias ad-ldap-cert -file ldap.cer -keystore ldap.truststore -storepass changeit
```
в bin/nifi-env.sh добавляем java параметр 
```
export BOOTSTRAP_JAVA_OPTS="-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true"
```

добавляем conf/bootstrap.conf
```
java.arg.18=-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true
```
конкретный номер `java.arg.№` может отличаться


правим conf/authorizers.xml:
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<authorizers>
    <userGroupProvider>
        <identifier>ldap-user-group-provider</identifier>
        <class>org.apache.nifi.ldap.tenants.LdapUserGroupProvider</class>
        <property name="Authentication Strategy">LDAPS</property>                                                                                                                                                    

        <property name="Manager DN">CN=Administrator,CN=Users,DC=example,DC=local</property>
        <property name="Manager Password">1qaz@WSX</property>

        <property name="TLS - Keystore"></property>
        <property name="TLS - Keystore Password"></property>
        <property name="TLS - Keystore Type"></property>
        <property name="TLS - Truststore">./ldap.truststore</property>
        <property name="TLS - Truststore Password">changeit</property>
        <property name="TLS - Truststore Type">jks</property>
        <property name="TLS - Client Auth"></property>
        <property name="TLS - Protocol">TLSv1.2</property>
        <property name="TLS - Shutdown Gracefully"></property>

        <property name="Referral Strategy">FOLLOW</property>
        <property name="Connect Timeout">10 secs</property>
        <property name="Read Timeout">10 secs</property>

        <property name="Url">ldaps://ldap.server.com:636</property>
        <property name="Page Size"></property>
        <property name="Sync Interval">30 mins</property>
        <property name="Group Membership - Enforce Case Sensitivity">false</property>

        <property name="User Search Base">CN=Users,DC=example,DC=local</property>
        <property name="User Object Class">person</property>
        <property name="User Search Scope">ONE_LEVEL</property>
        <property name="User Search Filter"></property>
        <property name="User Identity Attribute">cn</property>
        <property name="User Group Name Attribute">memberOf</property>
        <property name="User Group Name Attribute - Referenced Group Attribute"></property>

        <property name="Group Search Base">CN=Users,DC=example,DC=local</property>
        <property name="Group Object Class">group</property>
        <property name="Group Search Scope">ONE_LEVEL</property>
        <property name="Group Search Filter"></property>
        <property name="Group Name Attribute">cn</property>
        <property name="Group Member Attribute">member</property>
        <property name="Group Member Attribute - Referenced User Attribute"></property>
    </userGroupProvider>

    <accessPolicyProvider>
        <identifier>file-access-policy-provider</identifier>
        <class>org.apache.nifi.authorization.FileAccessPolicyProvider</class>
        <property name="User Group Provider">ldap-user-group-provider</property>
        <property name="Authorizations File">./conf/authorizations.xml</property>
        <property name="Initial Admin Identity">Administrator</property>
        <property name="Legacy Authorized Users File"></property>
        <property name="Node Identity 1"></property>
        <property name="Node Group"></property>
    </accessPolicyProvider>

    <authorizer>
        <identifier>managed-authorizer</identifier>
        <class>org.apache.nifi.authorization.StandardManagedAuthorizer</class>
        <property name="Access Policy Provider">file-access-policy-provider</property>
    </authorizer>

</authorizers>

```

Initial Admin Identity - указываем LDAP пользователя который получит права на вход в nifi

### затем можно запустить nifi !
```
systemctl start nifi.service
```


