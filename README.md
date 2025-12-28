# Koko
This repo has the files needed to install and configure my home server (`koko`) in just a few minutes using Ansible, Terragrunt and OpenTofu.

### Prerequisites
- Ansible, tofu and terragrunt installed in your local machine
- All secret and config files in `/bkp/tofu`
- Proxmox running in the server

## OpenTofu (External Services)
### Deploy Cloudflare DNS config
```sh
cd tofu/cloudflare
tofu init -backend-config=/bkp/tofu/backend.hcl
tofu plan -var-file=/bkp/tofu/cloudflare/terraform.tfvars
tofu apply -var-file=/bkp/tofu/cloudflare/terraform.tfvars
```

### Deploy OVH config
```sh
cd tofu/ovh
tofu init -backend-config=/bkp/tofu/backend.hcl
tofu plan -var-file=/bkp/tofu/ovh/terraform.tfvars
tofu apply -var-file=/bkp/tofu/ovh/terraform.tfvars
```

## Configure Proxmox
### Ansible
```bash
$ cd ~nahuel
$ git clone https://github.com/matandomuertos/koko.git
$ cd koko/ansible
$ ansible-galaxy install -r requirements.yml
$ ansible-playbook playbooks/init-kokopve.yml -i inventories/hosts.yml --ask-become-pass
```
- The `--ask-become-pass` option is required if your user is not root.
- You can run with `--check --diff` to see what changes would be applied without making them.

### Terragrunt
#### Deploy Proxmox Base config
```sh
cd tofu/proxmox_base
tofu init -backend-config=/bkp/tofu/backend.hcl
tofu plan -var-file=/bkp/tofu/proxmox/terraform.tfvars
tofu apply -var-file=/bkp/tofu/proxmox/terraform.tfvars
```

#### Deploy Proxmox VMs
```sh
cd tofu/proxmox
terragrunt run --all plan
terragrunt run --all apply
```

## Configure Koko server
```bash
$ cd ~nahuel
$ git clone https://github.com/matandomuertos/koko.git
$ cd koko/ansible
$ ansible-playbook playbooks/init-koko.yml -i inventories/hosts.yml --ask-become-pass
```

### Post-reboot instructions
- To enable the SkyConnect usb run `sudo modprobe cp210x` in the VM
- With the user `nahuel`, clone koko's repo (`git clone https://github.com/matandomuertos/koko.git`) and run `docker compose --profile prod --env-file /bkp/docker/envs -f ~/koko/docker/apps/docker-compose.yaml up -d` to run all the apps.
- To run all MCP servers run `docker compose --profile prod --env-file /bkp/docker/envs-mcp -f ~/koko/docker/mcp/docker-compose.yaml up -d`

## Docker
### Apps running
#### Apps
- [qBitorrent](https://hub.docker.com/r/linuxserver/qbittorrent)
- [Plex](https://hub.docker.com/r/linuxserver/plex)
- [Gitea](https://hub.docker.com/r/gitea/gitea)
- [Uptime kuma](https://hub.docker.com/r/louislam/uptime-kuma)
- [Koko Dashoard](https://github.com/matandomuertos/koko-dashboard)
- [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
- [Portainer](https://github.com/portainer/portainer)
- [Home Assistant](https://github.com/home-assistant)
- [Timemachine](https://hub.docker.com/r/mbentley/timemachine)
- [Rclone-mount](https://hub.docker.com/r/mumiehub/rclone-mount)
- [your-spotify](https://github.com/Yooooomi/your_spotify)
- [Varnish Cache](https://hub.docker.com/_/varnish)
- [NGINX Test web server](https://hub.docker.com/r/nginxdemos/hello/)

#### Networking
- [Traefik](https://github.com/traefik/traefik)
- [iPerf3](https://github.com/nerdalert/iperf3)

#### Monitoring
- [Prometheus Stack (Prom, Alertmanager, Grafana)](https://prometheus.io/)
- [cAdvisor](https://github.com/google/cadvisor)

#### Exporters
- [node-exporter](https://github.com/prometheus/node_exporter)
- [cadvisor](https://github.com/google/cadvisor)
- [qbittorrent-exporter](https://github.com/esanchezm/prometheus-qbittorrent-exporter)
- [proxmox-exporter](https://github.com/prometheus-pve/prometheus-pve-exporter)
- [varnish-exporter](https://github.com/jonnenauha/prometheus_varnish_exporter) (Built manually)

#### AI
- [Ollama](https://github.com/ollama/ollama)
- [Open WebUI](https://github.com/open-webui/open-webui)
- [n8n](https://github.com/n8n-io/n8n)

#### Apps tested but abandoned
- [Pi-hole](https://github.com/pi-hole/docker-pi-hole) - Not using it
- [cftunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) - Not using it
- [qBitorrent VPN](https://github.com/binhex/arch-qbittorrentvpn) - Moved back to standard qBitorrent
- [Watchover](https://github.com/containrrr/watchtower) - Quite overkill, the crontab works good enough
- [homer](https://github.com/bastienwirtz/homer) - Still prefer my custom dashboard
- [homarr](https://github.com/ajnart/homarr) - Still prefer my custom dashboard
- [cronmaster](https://github.com/fccview/cronmaster) - Web UI too heavy

### MCP Servers running
- [Prometheus](https://github.com/modelcontextprotocol/servers/tree/main/src/prometheus)
- [Terraform](https://github.com/modelcontextprotocol/servers/tree/main/src/terraform)
- [Slack](https://github.com/modelcontextprotocol/servers/tree/main/src/slack)
- [Grafana](https://github.com/grafana/mcp-grafana)

## PBS
- Installed from the ISO manually.
- Removed premium repositories manually.
- Basic config by ansible (`ansible-playbook playbooks/init-pbs.yml -i inventories/hosts.yml --ask-become-pass`).
- Datastore created manually.
- Added manually to Proxmox Cluster.
- VM backups created manually in Promox Cluster.

## Known issues
- Traefik takes a while to validate all the certs and, sometimes, it leaves unneeded entries in the Godaddy DNS config
- Plex is not using TLS, it seems it doesn't like reverse proxies and I was lazy to go deeper to fix it
- Homeassistant is not running behind Traefik because autodiscovery (mostly apple devices) needs `network_mode: host` and port `8123` to work

## What's next
There are a few more apps that could be tested and added to the init script:
- Prometheus/Grafana/Loki (right now the monitoring tool is uptime-kuma)
