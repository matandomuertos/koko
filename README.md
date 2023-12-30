# Koko
This repo has the files needed to install and configure my home server (`koko`) in just a few minutes.

## Warning :warning:
The script is designed to run only once and it does not include any checks for repeated runs. Running the script multiple times may result in failure and create unnecessary entries in the fstab or LVs.

## Requirements
- This repo assumes all Docker app config files are in `/bkp/docker` (`hdd-vg/bkp-lv`)
- Clean installation of [Ubuntu Server 22.04](https://ubuntu.com/download/server)
- An user: `nahuel`
- Server IP: `192.168.31.167`
- `35.42GB` of free space in the main VG
- LVM:
  - Main VG name: `ubuntu-vg`
  - For additional FS:
    - Additional VG name: `hdd-vg`
    - `hdd-vg` structure:
      - `download-lv` (ext4)
      - `bkp-lv` (ext4)
- [GoDaddy DNS entries](https://dcc.godaddy.com/control/):
  - Type A: `@` -> `192.168.31.167`
  - Type A: `*` -> `192.168.31.167`
  - Type A: `*.pub` -> NordVPN Meshnet IP

## How to use
```
$ cd ~nahuel
$ git clone https://github.com/matandomuertos/koko.git
$ cd koko
$ sudo ./init.sh
```

## What is doing?
- Disable APT news
- Update all packages
- Create and mount Docker volume (`/var/lib/docker`)
- Create and mount bkp-ssd volume (`/bkp-ssd`)
- Install and configure [docker-ce](https://docs.docker.com/engine/install/ubuntu/) (with compose plugin)
- Install PIP3
- Install [subliminal](https://github.com/Diaoul/subliminal)
- Clean up unused packages
- Configure root crontab based on [crontab](https://github.com/matandomuertos/koko/blob/main/crontab) file
- Customize resolv.conf (requires reboot)
- Reboot the system

## Post-reboot instructions
- With the user `nahuel`, go to the directory `koko` and run `docker compose up -d` to run all the apps

## Apps running
- [qBitorrent](https://hub.docker.com/r/linuxserver/qbittorrent)
- [Plex](https://hub.docker.com/r/linuxserver/plex)
- [Gitea](https://hub.docker.com/r/gitea/gitea)
- [Uptime kuma](https://hub.docker.com/r/louislam/uptime-kuma)
- [Koko Dashoard](https://github.com/matandomuertos/koko-dashboard)
- [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
- [Traefik](https://github.com/traefik/traefik)
- [cAdvisor](https://github.com/google/cadvisor)
- [iPerf3](https://github.com/nerdalert/iperf3)
- [Portainer](https://github.com/portainer/portainer)
- [Home Assistant](https://github.com/home-assistant)
- Test web server ([nginx](https://hub.docker.com/r/nginxdemos/hello/))

## Apps abandoned
- [Pi-hole](https://github.com/pi-hole/docker-pi-hole) - Simply not using it
- [Watchover](https://github.com/containrrr/watchtower) - Quite overkill, the crontab works good enough
- [homer](https://github.com/bastienwirtz/homer) - Still prefer my custom dashboard
- [homarr](https://github.com/ajnart/homarr) - Still prefer my custom dashboard

## Other apps
- [k3d](https://k3d.io/) was installed manually
- [NordVPN CLI](https://support.nordvpn.com/Connectivity/Linux/1325531132/Installing-and-using-NordVPN-on-Debian-Ubuntu-Raspberry-Pi-Elementary-OS-and-Linux-Mint.htm) was installed manually (and meshnet was configured manually too) 

## Known issues
- Traefik takes a while to validate all the certs and, sometimes, it leaves unneeded entries in the Godaddy DNS config
- Plex is not actually using TLS, it seems it doesn't like reverse proxies and I was lazy to go deeper to fix it
- Homeassistant is not running behind Traefik because autodiscovery (mostly apple devices) needs `network_mode: host` and port `8123` to work

## What's next
There are a few more apps that could be tested and added to the init script:
- Prometheus/Grafana/Loki (right now the monitoring tool is uptime-kuma)
- [FileBroswer](https://github.com/filebrowser/filebrowser)
- [Kasm](https://www.kasmweb.com/docs/latest/index.html)
- Backup docker FS and all secrets somewhere out of the server

