#!/bin/bash 

# Define setup steps
STEPS=(
  "apt update -y > /dev/null 2>&1"
  "DEBIAN_FRONTEND=noninteractive apt upgrade -yq > /dev/null 2>&1"
  "apt install -y neofetch figlet lolcat > /dev/null 2>&1"
  "echo '' > /etc/motd"
  "sed -i 's/^#*PrintMotd.*/PrintMotd yes/' /etc/ssh/sshd_config"
  "systemctl restart ssh > /dev/null 2>&1"
  "rm -f /etc/profile.d/voidzero-banner.sh"
)

TOTAL=${#STEPS[@]}

# Spinner + % display
run_with_progress() {
  local i=0
  local percent=0
  local spin_chars='-\|/'

  for cmd in "${STEPS[@]}"; do
    bash -c "$cmd" &
    pid=$!

    while kill -0 $pid 2>/dev/null; do
      percent=$(( (i * 100) / TOTAL ))
      spin_char=${spin_chars:i%4:1}
      printf "\r\e[1;36m🌐 Please wait... Setting up your VoidZero VPS | %d%%\e[0m" "$percent"
      sleep 0.1
    done

    wait $pid
    ((i++))
  done

  printf "\r\e[1;36m🌐 Please wait... Setting up your VoidZero VPS ✔ 100%%\e[0m\n"
}

# Banner that shows on SSH login
create_banner_script() {
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
}

# Run it all
run_with_progress
create_banner_script

# Final success message
echo -e "\e[1;32m✅ VoidZero VPS banner setup complete!\e[0m"

# Reload shell to avoid logout/login
exec bash --login
