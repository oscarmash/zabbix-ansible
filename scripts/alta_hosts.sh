#!/usr/bin/bash

IP_ZABBIX="172.26.0.254"

# Recupera el token post Login
export TOKEN=$(curl -s -H "Content-type: application/json-rpc" -X POST http://$IP_ZABBIX/api_jsonrpc.php -d'
{
   "jsonrpc": "2.0",
   "method": "user.login",
   "params": {
      "user": "Admin",
      "password": "zabbix"
   },
   "id": 1
}' | jq -r .result)

# Lee el fichero de Hosts y los crea en zabbix via API
while read line; do
 HOSTNAME="$(cut -d':' -f1 <<< "$line")"
 IPADDR="$(cut -d':' -f2 <<< "$line")"
 DESCRIPCION="$(cut -d':' -f3 <<< "$line")"

 CDATA(){
  cat <<EOF
{
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": "${HOSTNAME}",
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": "${IPADDR}",
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": "2"
            }
        ],
        "tags": [
            {
                "tag": "Host name",
                "value": "${DESCRIPCION}"
            }
        ],
        "templates": [
            {
                "templateid": "10001"
            }
        ]
    },
    "auth": "${TOKEN}",
    "id": 1
}
EOF
}

 # Realiza la llamada para crear los hosts
 curl -s -H "Content-type: application/json-rpc" -X POST http://$IP_ZABBIX/api_jsonrpc.php --data "$(CDATA)"
done<listado_hosts