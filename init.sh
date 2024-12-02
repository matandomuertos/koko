# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Init message
echo "Initializing Koko..."
echo "Check logs in /tmp/init-output.txt"

# Hide APT news
echo "Disabling APT news"
pro config set apt_news=false >> /tmp/init-output.txt 2>&1

# Update system
echo "Update system"
apt update >> /tmp/init-output.txt 2>&1
apt upgrade -y >> /tmp/init-output.txt 2>&1

# Create docker's filesystem
echo "Creating docker FS"
lvcreate -L 35.42G -n docker-lv ubuntu-vg >> /tmp/init-output.txt 2>&1 || exit 1
mkfs.xfs /dev/ubuntu-vg/docker-lv >> /tmp/init-output.txt 2>&1 || exit 1
mkdir -p /var/lib/docker
echo "/dev/mapper/ubuntu--vg-docker--lv /var/lib/docker xfs defaults 1 1" >> /etc/fstab
mount -a > /tmp/init-output.txt 2>&1 || exit 1

# Create bkp-ssd's filesystem
echo "Creating bkp-ssd FS"
lvcreate -L 20G -n bkpssd-lv ubuntu-vg >> /tmp/init-output.txt 2>&1 || exit 1
mkfs.xfs /dev/ubuntu-vg/bkpssd-lv >> /tmp/init-output.txt 2>&1 || exit 1
mkdir -p /bkp-ssd
echo "/dev/mapper/ubuntu--vg-bkpssd--lv /bkp-ssd xfs defaults 1 1" >> /etc/fstab
mount -a >> /tmp/init-output.txt 2>&1 || exit 1

# Create usb-apollo's filesystem
apt install -y hdparm >> /tmp/init-output.txt 2>&1
echo "Creating usb/apollo FS"
mkdir -p /usb/apollo
echo "/dev/sdc1 /usb/apollo xfs defaults,nofail 0 2" >> /etc/fstab
mount -a >> /tmp/init-output.txt 2>&1 || exit 1
hdparm -S 15 /dev/sdc >> /tmp/init-output.txt 2>&1 #Standby mode after 1 minute

# Create rclone/gdrive directory
echo "Creating rclone directory"
mkdir -p /rclone/gdrive

# Install docker
echo "Installing Docker"
apt remove -y docker docker.io containerd runc >> /tmp/init-output.txt 2>&1
apt install -y ca-certificates curl gnupg lsb-release >> /tmp/init-output.txt 2>&1
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg >> /tmp/init-output.txt 2>&1
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >> /dev/null
apt update >> /tmp/init-output.txt 2>&1
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin >> /tmp/init-output.txt 2>&1 
systemctl enable --now docker >> /tmp/init-output.txt 2>&1
usermod -aG docker nahuel >> /tmp/init-output.txt 2>&1

# Create link to docker env var
echo "Creating link to docker env variables"
ln -s /bkp/docker/envs ~/nahuel/koko/.env

# Install PIP3 and subliminal
echo "Installing PIP3"
apt install -y python3-pip >> /tmp/init-output.txt 2>&1
pip3 install subliminal >> /tmp/init-output.txt 2>&1

# Install network manager and disable wifi
echo "Installing network-manager"
apt install -y network-manager >> /tmp/init-output.txt 2>&1
echo "Disabling WIFI (use 'nmcli radio wifi on' to enable it)"
nmcli radio wifi off >> /tmp/init-output.txt 2>&1

# Clean up everything
echo "Cleaning up unused packages"
apt autoremove -y >> /tmp/init-output.txt 2>&1

# Configure root crontab
echo "Configuring root crontab"
crontab crontab >> /tmp/init-output.txt 2>&1

# Add Google DNS to resolv.conf and disable port 53 used by system
echo "Customizing resolv.conf"
echo "DNS=8.8.8.8 8.8.4.4" >> /etc/systemd/resolved.conf
echo "DNSStubListener=no" >> /etc/systemd/resolved.conf
lnln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf >> /tmp/init-output.txt 2>&1

# Reboot
echo "Rebooting in 5 sec..."
sleep 5 || reboot
