# Instalación Zabbix Server con Docker

## Instalación con Ansible

Fácil:

```
$ ansible-playbook xxxx.yaml
```

NOTA: aunque arranquen los contenedores, tarda un rato, ya que ha de crear el schema

## Cambios a realizar a mano

Acceder por IP -> Admin/zabbix 
Cambiar el "Zabbix server" de 127.0.0.1 a "zabbix_agent" y connect por DNS

# Instalación Zabbix agent

## Instalación con Ansible

Primero hemos de modificar el fichero inventory

```
vault ansible_host=172.26.0.254
```

Y lanzamos el ansible

```
$ ansible-playbook install_zabbix-agent2.yaml
```

## Instalación agente zabbix a mano

```
apt-get update
apt-get install zabbix-agent
vim /etc/zabbix/zabbix_agentd.conf
  Server=172.26.0.13
  ServerActive=172.26.0.13
  Hostname=mldonkey
systemctl restart zabbix-agent && systemctl status zabbix-agent
```

## Instalación agente zabbix2 a mano

```
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bdebian11_all.deb
dpkg -i zabbix-release_6.0-4+debian11_all.deb
apt update && apt install zabbix-agent2
vim /etc/zabbix/zabbix_agent2.conf
  Server=172.26.0.13
  ServerActive=172.26.0.13
  Hostname=mldonkey
systemctl restart zabbix-agent2 && systemctl enable zabbix-agent2 && systemctl status zabbix-agent2
```

Si tiene cosas de Docker: usermod -aG docker zabbix

# Varios

## Conexión a la BBDD

```
$ mysql -h 172.26.0.254 -u root -p
```

