#!/bin/bash

# Check if the script is run with root privileges
if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run with root privileges."
  exit 1
fi

# Prompt for the new username
read -p "Enter the new username: " new_username

# Prompt for the sudo option
read -p "Do you want to add the user to the sudo group? (yes/no): " sudo_option

# Step 1: Create the new user account
echo "Creating user account..."
useradd -m -s /bin/bash "$new_username"
passwd "$new_username" # You will be prompted to set a password for the new user

# Step 2: Copy SSH keys from the root user to the new user
echo "Copying SSH keys..."
mkdir -p "/home/$new_username/.ssh"
cp -rf /root/.ssh/authorized_keys "/home/$new_username/.ssh/"
chown -R "$new_username:$new_username" "/home/$new_username/.ssh"
chmod 700 "/home/$new_username/.ssh"
chmod 600 "/home/$new_username/.ssh/authorized_keys"

# Step 3: Disable password login for the new user
echo "Disabling password login for the new user..."
sed -i -e '/^PasswordAuthentication/s/^/#/' /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
service ssh restart

# Step 4: Add the new user to the sudo group if the option is yes
if [[ "$sudo_option" == "yes" ]]; then
  echo "Adding user to sudo group..."
  usermod -aG sudo "$new_username"
fi

echo "User account setup complete!"
