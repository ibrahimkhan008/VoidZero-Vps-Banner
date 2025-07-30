#!/bin/bash

# Function to show spinner while tasks run
spinner() {
  local pid=$!
  local spin='-\|/'
  local i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r\e[1;36m🌐 Please wait... Setting up your VoidZero VPS ${spin:$i:1} \e[0m"
    sleep 0.1
  done
}

# Start spinner in background
(
  apt update -y &> /dev/null
  apt upgrade -y &> /dev/null
  apt install -y neofetch figlet lolcat &> /dev/null

  rm -f /etc/motd
  sed -i 's/^#*PrintMotd.*/PrintMotd yes/' /etc/ssh/sshd_config
  systemctl restart ssh &> /dev/null
  rm -f /etc/profile.d/voidzero-banner.sh

  # Create the banner display script
  cat << 'EOF' > /etc/profile.d/voidzero-banner.sh
#!/bin/bash
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
  echo -e "\e[1;32m🚀 Welcome to VoidZero VPS Service 🚀\e[0m"
  echo
  neofetch --color_blocks off --disable resolution wm theme icons font
  echo
fi
EOF

  chmod +x /etc/profile.d/voidzero-banner.sh
) & spinner

# Show finish message
printf "\n\e[1;32m✅ VoidZero VPS banner setup complete!\e[0m\n"
