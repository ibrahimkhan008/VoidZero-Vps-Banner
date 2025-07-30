#!/bin/bash

# Update & install required tools
apt update -y
apt install -y neofetch figlet lolcat

# Disable static motd
rm -f /etc/motd

# Ensure SSH prints motd
sed -i 's/^#*PrintMotd.*/PrintMotd yes/' /etc/ssh/sshd_config
systemctl restart ssh

# Create custom motd script
cat << 'EOF' > /etc/update-motd.d/00-custom
#!/bin/bash
clear

cat << "ART" | lolcat
██╗   ██╗ ██████╗ ██╗██████╗ ███████╗███████╗██████╗  ██████╗
██║   ██║██╔═══██╗██║██╔══██╗╚══███╔╝██╔════╝██╔══██╗██╔═══██╗
██║   ██║██║   ██║██║██║  ██║  ███╔╝ █████╗  ██████╔╝██║   ██║
╚██╗ ██╔╝██║   ██║██║██║  ██║ ███╔╝  ██╔══╝  ██╔══██╗██║   ██║
 ╚████╔╝ ╚██████╔╝██║██████╔╝███████╗███████╗██║  ██║╚██████╔╝
  ╚═══╝   ╚═════╝ ╚═╝╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝
ART

echo -e "\e[1;32m🚀 Welcome to VoidZero VPS 🚀\e[0m"
echo
neofetch --color_blocks off --disable resolution wm theme icons font
echo
EOF

# Make script executable
chmod +x /etc/update-motd.d/00-custom

# OPTIONAL: Regenerate for current session (not needed on next SSH login)
run-parts /etc/update-motd.d/ > /run/motd.dynamic
