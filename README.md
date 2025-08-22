# Koko
This repo has the files needed to install and configure my home server (`koko`) in just a few minutes using Ansible.

## Requirements
- A clean installation of [Ubuntu Server 22.04](https://ubuntu.com/download/server)
- User: `nahuel`
- Server IP: `192.168.0.39`
- Main VG: `ubuntu-vg` with at least `35.42GB` free
- LVM structure for additional FS:
  - VG name: `hdd-vg`
    - `download-lv` (ext4)
    - `bkp-lv` (ext4)
- Docker app configuration files located in `/bkp/docker`
- DNS managed via [Cloudflare](https://www.cloudflare.com/):
  - Type A: `*` -> `192.168.0.39`

## How to use
```bash
$ cd ~nahuel
$ git clone https://github.com/matandomuertos/koko.git
$ cd koko/ansible
$ ansible-playbook playbooks/init-koko.yml -i inventories/hosts -e 'wifi_ssid=WifiSSID wifi_password=WifiPassword' --ask-become-pass
```
- The `--ask-become-pass` option is required if your user is not root.
- You can run with `--check --diff` to see what changes would be applied without making them.

## What is doing?
- Disable APT news
- Update all installed packages
- Install Python, hdparm, network manager, Docker, KVM, LXC and K3d
- Create and mount Docker volume (`/var/lib/docker`)
- Create and mount bkp-ssd volume (`/bkp-ssd`)
- Configure optional USB mount (`/usb/apollo`) and standby (via hdparm)
- Configure network via netplan
- Configure root crontab
- Reboot the system

## Post-reboot instructions
- With the user `nahuel`, go to the directory `koko` (`git clone https://github.com/matandomuertos/koko.git`) and run `docker compose up -d` to run all the apps.

## Apps running (Docker)
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
- [Traefik](https://github.com/traefik/traefik)
- [Prometheus Stack](https://prometheus.io/)
- [cAdvisor](https://github.com/google/cadvisor)
- [iPerf3](https://github.com/nerdalert/iperf3)
- [Ollama](https://github.com/ollama/ollama)
- [Open WebUI](https://github.com/open-webui/open-webui)

## Apps Test (Docker)
- [NGINX Test web server](https://hub.docker.com/r/nginxdemos/hello/)
- [n8n](https://github.com/n8n-io/n8n)

## Apps abandoned (Docker)
- [Pi-hole](https://github.com/pi-hole/docker-pi-hole) - Not using it
- [cftunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) - Not using it
- [qBitorrent VPN](https://github.com/binhex/arch-qbittorrentvpn) - Moved back to standard qBitorrent
- [Watchover](https://github.com/containrrr/watchtower) - Quite overkill, the crontab works good enough
- [homer](https://github.com/bastienwirtz/homer) - Still prefer my custom dashboard
- [homarr](https://github.com/ajnart/homarr) - Still prefer my custom dashboard

## Known issues
- Traefik takes a while to validate all the certs and, sometimes, it leaves unneeded entries in the Godaddy DNS config
- Plex is not actually using TLS, it seems it doesn't like reverse proxies and I was lazy to go deeper to fix it
- Homeassistant is not running behind Traefik because autodiscovery (mostly apple devices) needs `network_mode: host` and port `8123` to work

## What's next
There are a few more apps that could be tested and added to the init script:
- Prometheus/Grafana/Loki (right now the monitoring tool is uptime-kuma) -> Prom and Grafana already running
- [FileBroswer](https://github.com/filebrowser/filebrowser)
- [Kasm](https://www.kasmweb.com/docs/latest/index.html)
- Backup docker FS and all secrets somewhere out of the server
