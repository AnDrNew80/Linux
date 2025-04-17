#  debian-user-setup

**Automatic Bash script to create users on Debian, set passwords, assign them to groups and log all operations.**

---

##  Contents

- `user_setup.sh` – main script to automate user creation
- `users.txt` – list of users and groups assigned to them
- `hasla/` – generated passwords (each user has their own file)
- `user_setup.log` – log with information about the operations performed

---

##  Requirements

- System Linux (np. **Debian**)
- Administrator rights (**sudo/root**)
- Installed: `bash`, `openssl`, `useradd`, `chpasswd`

---

##  Installation and use

1. Clone repository:
   ```bash
   git clone https://github.com/TWOJANAZWA/debian-user-setup.git
   cd debian-user-setup
