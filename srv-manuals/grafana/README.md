# Grafana

## настройка LDAPS

в config/defaults.ini должен быть указан путь к конфигурации LDAP
```
#################################### Auth LDAP ###########################
[auth.ldap]
enabled = true                                                                                                                                                                                                   
config_file = /path/to/grafana/conf/ldap.toml
allow_sign_up = true

# LDAP backround sync (Enterprise only)
# At 1 am every day
sync_cron = "0 0 1 * * *"
active_sync_enabled = true

```

затем правим настройки в conf/ldap.toml
```
[[servers]]
host = "ldap.server.com"
port = 636
use_ssl = true
start_tls = false
ssl_skip_verify = true

bind_dn = "CN=Administrator,CN=Users,DC=example,DC=local"
bind_password = '1qaz@WSX'

search_filter = "(sAMAccountName=%s)"

search_base_dns = ["dc=example,dc=local"]

[servers.attributes]
name = "givenName"
surname = "sn"
username = "cn"
member_of = "memberOf"
email =  "email"

[[servers.group_mappings]]
group_dn = "cn=admins,ou=groups,dc=grafana,dc=org"
org_role = "Admin"

[[servers.group_mappings]]
group_dn = "cn=users,ou=groups,dc=grafana,dc=org"
org_role = "Editor"

[[servers.group_mappings]]
group_dn = "*"
org_role = "Viewer"

```
