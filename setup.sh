#!/bin/bash

# Update & install tools
apt update -y
apt install -y neofetch figlet lolcat

# Disable old static MOTD
rm -f /etc/motd

# Make sure SSH will show the MOTD
sed -i 's/^#*PrintMotd.*/PrintMotd yes/' /etc/ssh/sshd_config
systemctl restart ssh

# Create custom MOTD script
cat << 'EOF' > /etc/profile.d/voidzero-banner.sh
#!/bin/bash
# This runs at every login shell

# Only show if it's an SSH session
if [ -n "$SSH_CONNECTION" ]; then
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
fi
EOF

# Make it executable
chmod +x /etc/profile.d/voidzero-banner.sh
