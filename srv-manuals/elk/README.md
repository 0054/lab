# настройка opendisto

минимальный конфиг (для ноды elk-1) для кластера из 3х нод ( elk-1 elk-2 elk-3 )
```
cluster.name: elk-test
node.name: node-1
node.master: true
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
discovery.seed_hosts: ["elk-2", "elk-3"]
cluster.initial_master_nodes: ["10.10.1.31", "10.10.1.32", "10.10.1.33"]
opendistro_security.ssl.transport.pemcert_filepath: esnode.pem
opendistro_security.ssl.transport.pemkey_filepath: esnode-key.pem
opendistro_security.ssl.transport.pemtrustedcas_filepath: root-ca.pem
opendistro_security.ssl.transport.enforce_hostname_verification: false
opendistro_security.ssl.http.enabled: true
opendistro_security.ssl.http.pemcert_filepath: esnode.pem
opendistro_security.ssl.http.pemkey_filepath: esnode-key.pem
opendistro_security.ssl.http.pemtrustedcas_filepath: root-ca.pem
opendistro_security.allow_unsafe_democertificates: true
opendistro_security.allow_default_init_securityindex: true
opendistro_security.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test, C=de
opendistro_security.audit.type: internal_elasticsearch
opendistro_security.enable_snapshot_restore_privilege: true
opendistro_security.check_snapshot_restore_write_privileges: true
opendistro_security.restapi.roles_enabled: ["all_access", "security_rest_api_access"]
cluster.routing.allocation.disk.threshold_enabled: false
node.max_local_storage_nodes: 3
```


## openssl
в кратце суть в том чтобы сгенерить пачку сертификатов подсунуть их в конфиг эластика, затем запустить эластик и запустить скрип который обновит секурити индекс в эластике

Generate a private key:
```
openssl genrsa -out root-ca-key.pem 2048
```
Generate a root certificate:
```
penssl req -new -x509 -days 3650 -sha256 -key root-ca-key.pem -out root-ca.pem
```
Generate an admin certificate:
```
openssl genrsa -out admin-key-temp.pem 2048
```
затем конвертируем этот ключ в формат понятный для java:
```
openssl pkcs8 -inform PEM -outform PEM -in admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin-key.pem
```
подписываем сертификат:
```
openssl req -new -key admin-key.pem -out admin.csr
```
геренируем серт:
```
openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out admin.pem
```

скрипт:
```
#!/bin/bash
# Root CA
echo --------------------------------------------
echo Generate a root certificate
echo --------------------------------------------
openssl genrsa -out root-ca-key.pem 2048
openssl req -new -x509 -sha256 -key root-ca-key.pem -out root-ca.pem
# Admin cert
echo --------------------------------------------
echo Generate an admin certificate
echo --------------------------------------------
openssl genrsa -out admin-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin-key.pem
openssl req -new -key admin-key.pem -out admin.csr
openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out admin.pem
# fvm230 Node cert
echo --------------------------------------------
echo Generate an fvm230 node certificate
echo --------------------------------------------
openssl genrsa -out fvm230-node-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in fvm230-node-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out fvm230-node-key.pem
openssl req -new -key fvm230-node-key.pem -out fvm230-node.csr
openssl x509 -req -in fvm230-node.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out fvm230-node.pem
# fvm231 Node cert
echo --------------------------------------------
echo Generate an fvm231 node certificate
echo --------------------------------------------
openssl genrsa -out fvm231-node-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in fvm231-node-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out fvm231-node-key.pem
openssl req -new -key fvm231-node-key.pem -out fvm231-node.csr
openssl x509 -req -in fvm231-node.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out fvm231-node.pem
# fvm232 Node cert
echo --------------------------------------------
echo Generate an fvm232 node certificate
echo --------------------------------------------
openssl genrsa -out fvm232-node-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in fvm232-node-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out fvm232-node-key.pem
openssl req -new -key fvm232-node-key.pem -out fvm232-node.csr
openssl x509 -req -in fvm232-node.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out fvm232-node.pem
# kibana cert
echo --------------------------------------------
echo Generate an kibana certificate
echo --------------------------------------------
openssl genrsa -out kibana-key-temp.pem 2048
openssl pkcs8 -inform PEM -outform PEM -in kibana-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out kibana-key.pem
openssl req -new -key kibana-key.pem -out kibana.csr
openssl x509 -req -in kibana.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out kibana.pem
# Cleanup
rm admin-key-temp.pem
rm admin.csr
rm fvm230-node-key-temp.pem
rm fvm230-node.csr
rm fvm231-node-key-temp.pem
rm fvm231-node.csr
rm fvm232-node-key-temp.pem
rm fvm232-node.csr
rm kibana-key-temp.pem
rm kibana.csr

```

```
openssl x509 -subject -nameopt RFC2253 -noout -in ssl/admin.pem
```

раскидываем этот конфиг по всем нодам
делаем подобный конфиг и запускаем эластик:
```
cluster.name: elk-test
node.name: node-fvm230.lpr.jet.msk.su
node.master: true
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
discovery.seed_hosts: ['fvm230.lpr.jet.msk.su', 'fvm231.lpr.jet.msk.su', 'fvm232.lpr.jet.msk.su']
cluster.initial_master_nodes: ['10.31.11.230','10.31.11.231','10.31.11.232']
opendistro_security.ssl.transport.pemcert_filepath: ssl/fvm230-node.pem
opendistro_security.ssl.transport.pemkey_filepath: ssl/fvm230-node-key.pem
opendistro_security.ssl.transport.pemtrustedcas_filepath: ssl/root-ca.pem
opendistro_security.ssl.transport.enforce_hostname_verification: false
opendistro_security.ssl.http.enabled: true
opendistro_security.ssl.http.pemcert_filepath: ssl/fvm230-node.pem
opendistro_security.ssl.http.pemkey_filepath: ssl/fvm230-node-key.pem
opendistro_security.ssl.http.pemtrustedcas_filepath: ssl/root-ca.pem
opendistro_security.allow_unsafe_democertificates: true
opendistro_security.allow_default_init_securityindex: true
opendistro_security.authcz.admin_dn:
  - CN=*.lpr.jet.msk.su,O=Default Company Ltd,L=Default City,C=XX
opendistro_security.nodes_dn:
  - 'CN=fvm230.lpr.jet.msk.su,O=Default Company Ltd,L=Default City,C=XX'
  - 'CN=fvm231.lpr.jet.msk.su,O=Default Company Ltd,L=Default City,C=XX'
  - 'CN=fvm232.lpr.jet.msk.su,O=Default Company Ltd,L=Default City,C=XX'
opendistro_security.audit.type: internal_elasticsearch
opendistro_security.enable_snapshot_restore_privilege: true
opendistro_security.check_snapshot_restore_write_privileges: true
opendistro_security.restapi.roles_enabled: ["all_access", "security_rest_api_access"]
cluster.routing.allocation.disk.threshold_enabled: false
node.max_local_storage_nodes: 3
```

затем идём в /usr/share/elasticsearch/plugins/opendistro_security/tools
и обновляем / создаём .opendistro_security индекс
```
./securityadmin.sh -cd ../securityconfig/ -icl -nhnv -cacert /etc/elasticsearch/ssl/root-ca.pem -cert /etc/elasticsearch/ssl/admin.pem -key /etc/elasticsearch/ssl/admin-key.pem
```


# Настрока kibana SSL
конфиг /etc/kibana/kibana.yml:

```
server.host: "0.0.0.0"
server.ssl.enabled: true
server.ssl.certificate: /etc/kibana/ssl/kibana.pem
server.ssl.key: /etc/kibana/ssl/kibana-key.pem

opendistro_security.allow_client_certificates: true
elasticsearch.hosts: https://localhost:9200
elasticsearch.username: kibanaserver
elasticsearch.password: kibanaserver
elasticsearch.requestHeadersWhitelist: ["securitytenant","Authorization"]
elasticsearch.ssl.certificate: /etc/kibana/ssl/kibana.pem
elasticsearch.ssl.key: /etc/kibana/ssl/kibana-key.pem
elasticsearch.ssl.certificateAuthorities: ["/etc/kibana/ssl/root-ca.pem"]
elasticsearch.ssl.verificationMode: none



opendistro_security.multitenancy.enabled: true
opendistro_security.multitenancy.tenants.preferred: ["Private", "Global"]
opendistro_security.readonly_mode.roles: ["kibana_read_only"]

newsfeed.enabled: false
telemetry.optIn: false
telemetry.enabled: false
```

