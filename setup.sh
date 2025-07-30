#!/bin/bash

# Update & install required tools
apt update -y
apt install -y neofetch figlet lolcat

# Remove old static MOTD
rm -f /etc/motd

# Ensure PrintMotd is enabled in SSH config
sed -i 's/^#*PrintMotd.*/PrintMotd yes/' /etc/ssh/sshd_config
systemctl restart ssh

# Create custom MOTD script
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

# Make the custom MOTD script executable
chmod +x /etc/update-motd.d/00-custom

# Generate MOTD for current session
run-parts /etc/update-motd.d/ > /run/motd.dynamic

# Ensure /etc/motd points to the dynamic file (backward compatibility)
ln -sf /run/motd.dynamic /etc/motd
