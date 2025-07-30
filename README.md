# VoidZero VPS Banner Setup 🚀

This is an all-in-one Bash script to install a stylish and informative SSH login banner for your VoidZero VPS. It includes system information via `neofetch`, a colored ASCII logo, and a welcome message — all triggered automatically when you SSH into your VPS.

---

## 🔧 What It Does

- Updates and upgrades your system silently
- Installs required packages: `neofetch`, `figlet`, `lolcat`
- Enables SSH login message (`PrintMotd`)
- Creates a persistent login banner using `/etc/profile.d`
- Auto-displays system info only on SSH login
- Cleans up and replaces previous banners

---

## 📥 How to Use

Run the script with a single command (make sure `curl` is installed):

```bash
curl -sL "https://raw.githubusercontent.com/ibrahimkhan008/VoidZero-Vps-Banner/main/setup.sh" | bash
