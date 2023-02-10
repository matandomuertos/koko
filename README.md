# Koko
This repo has the files needed to install and configure Koko (the name of my home server) in only few minutes.

## Warning :warning:
The script is designed to be run only once and does not include any checks for repeated runs. Running the script multiple times may result in failure and create unnecessary entries in the fstab or LVs.

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
  - Type A: `test` -> Public IP (if you wanna to expose test.domain.com to the world, you will need, also, to expose the port 80 and 443 on your router configuration)

## How to use
```
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
- With the user `nahuel`, run `docker compose up -d` to run all the apps
- Router DNS configuration:
  - Primary: `192.168.31.167` (Pi-hole in Koko)
  - Secondary: `8.8.8.8` (Google primary DNS) -> This makes pi-hole useless because it won't block ads

## Apps running
- [qBitorrent](https://hub.docker.com/r/linuxserver/qbittorrent)
- [Plex](https://hub.docker.com/r/linuxserver/plex)
- [Gitea](https://hub.docker.com/r/gitea/gitea)
- [Uptime kuma](https://hub.docker.com/r/louislam/uptime-kuma)
- [Koko Dashoard](https://github.com/matandomuertos/koko-dashboard)
- [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
- [Pi-hole](https://github.com/pi-hole/docker-pi-hole) 
- [Traefik](https://github.com/traefik/traefik)
- [cAdvisor](https://github.com/google/cadvisor)
- [iPerf3](https://github.com/nerdalert/iperf3)
- Test web server

## What's next
There are a few more apps that could be tested and added to the init script:
- [k3s](https://github.com/k3s-io/k3s)
- Prometheus/Grafana/Loki (right now the monitoring tool is uptime-kuma)
- [Portainer](https://github.com/portainer/portainer)
- [Home Assistant](https://github.com/home-assistant)
- [FileBroswer](https://github.com/filebrowser/filebrowser)

## Known issues
- Traefik takes a while to validate all the certs and, sometimes, it leaves unneeded entries in the Godaddy DNS config

