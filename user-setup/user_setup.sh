#!/bin/bash
#This project contains a script `user_setup.sh` that automatically creates users on a Debian system, assigns them groups, generates secure passwords, and saves them to separate files. 
#The script also creates a log of all operations performed.

USER_FILE="users.txt"
PASS_DIR="Passwords"
LOG_FILE="user_setup.log"

# Create a directory for passwords if it does not exist
mkdir -p "$PASS_DIR"
touch "$LOG_FILE"

echo "[INFO] Start user configuration: $(date)" >> "$LOG_FILE"

while IFS=, read -r username groupname; do
    if id "$username" &>/dev/null; then
        echo "[WARN] User $username already exists. Skip." >> "$LOG_FILE"
        continue
    fi

    # Creating a user with a default home folder
    useradd -m "$username" -s /bin/bash

    # Add to groups
    if [ -n "$groupname" ]; then
        groupadd -f "$groupname"
        usermod -aG "$groupname" "$username"
    fi

    # Generating Password
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd

    # Saving the password to a file
    echo "$password" > "$PASS_DIR/${username}.txt"
    chmod 600 "$PASS_DIR/${username}.txt"

    # Logs
    echo "[INFO] User added: $username" >> "$LOG_FILE"
    echo "        Group: $groupname" >> "$LOG_FILE"
    echo "        Home directory: /home/$username" >> "$LOG_FILE"
    echo "        Shell: /bin/bash" >> "$LOG_FILE"
    echo "        Password saved in: $PASS_DIR/${username}.txt" >> "$LOG_FILE"

done < "$USER_FILE"

echo "[INFO] User setup is complete: $(date)" >> "$LOG_FILE"
