#!/bin/bash

# Check if the script is run with root privileges
if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run with root privileges."
  exit 1
fi

# Check if the username argument is provided
if [[ -z "$1" ]]; then
  echo "Usage: $0 <new_username>"
  exit 1
fi

# Set the new username from the provided argument
new_username="$1"

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

echo "User account setup complete!"