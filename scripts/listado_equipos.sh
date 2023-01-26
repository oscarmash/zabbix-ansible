#!/usr/bin/bash

# Sacar solo los nombres: ./listado_equipos.sh | grep 'host":' | awk '{print $2}'

IP_ZABBIX="10.16.0.3"
ZABBIX_USERNAME="Admin"
ZABBIX_PASSWORD="5draxgevEk"

generate_token_data()
{
  cat <<EOF
{
  "jsonrpc": "2.0",
  "method": "user.login",
  "params": {
    "user": "$ZABBIX_USERNAME",
    "password": "$ZABBIX_PASSWORD"}, 
  "id": 1,
  "auth": null
  }
EOF
}

export TOKEN=$(curl -s -H "Content-Type: application/json" \
  --request POST \
  --data "$(generate_token_data)" \
  "http://$IP_ZABBIX/zabbix/api_jsonrpc.php" | jq -r .result)

generate_post_data()
{
  cat <<EOF
{
  "jsonrpc": "2.0", 
  "method": "host.get", 
  "params": {
    "output": ["host"], 
    "selectInterfaces": ["interfaceid", "ip"]}, 
    "id": 2, 
    "auth": "$TOKEN"
    }
EOF
}

curl -s -H "Content-Type: application/json" \
  --request POST \
  --data "$(generate_post_data)" \
  "http://$IP_ZABBIX/zabbix/api_jsonrpc.php" | jq -r