#!/bin/bash
#Assigment 2
#Linux Automation Comp 2137
#prof. Dennis simpson

# Configure the network with the correct IP address
echo "Configuring network..."

NETPLAN_CONFIG="/etc/netplan/00-installer-config.yaml"

# Check if the IP is already set to 192.168.16.21
if ! grep -q "192.168.16.21/24" "$NETPLAN_CONFIG"; then
  echo "Updating netplan configuration..."

  # Disable DHCP and set static IP
  sudo sed -i 's/dhcp4: true/dhcp4: false/' "$NETPLAN_CONFIG"
  sudo sed -i 's/address: .*$/address: 192.168.16.21\/24/' "$NETPLAN_CONFIG"
  # Apply the network changes
  sudo netplan apply
  echo "Network configuration updated to 192.168.16.21/24."
else
  echo "Network configuration already set to 192.168.16.21."
fi

# Configure /etc/hosts file to associate hostname with IP
echo "Configuring /etc/hosts..."
if ! grep -q "192.168.16.21 server1" /etc/hosts; then
  echo "192.168.16.21 server1" | sudo tee -a /etc/hosts > /dev/null
  echo "/etc/hosts updated with 192.168.16.21 server1."
else
  echo "/etc/hosts already contains the correct entry."
fi

# Install Apache2 and Squid
echo "Installing Apache2 and Squid..."
sudo apt update
sudo apt install -y apache2 squid

# Enable and start Apache2 and Squid services
echo "Enabling and starting Apache2 and Squid services..."
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl enable squid
sudo systemctl start squid

# Create user accounts and configure SSH keys
declare -a users=("dennis" "aubrey" "captain" "snibbles" "brownie" "scooter" "sandy" "perrier" "cindy" "tiger" "yoda")

for user in "${users[@]}"; do
  if ! id "$user" &>/dev/null; then
    echo "Creating user $user..."
    sudo useradd -m -s /bin/bash "$user"
  else
    echo "User $user already exists."
  fi
done

# Add SSH keys for each user
echo "Adding SSH keys..."
for user in "${users[@]}"; do
  sudo mkdir -p /home/$user/.ssh
  # Here you need to replace the key with the actual public key for each user
  echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm" | sudo tee /home/$user/.ssh/authorized_keys > /dev/null
  sudo chmod 700 /home/$user/.ssh
  sudo chmod 600 /home/$user/.ssh/authorized_keys
  sudo chown -R $user:$user /home/$user/.ssh
done

# To Grant 'dennis' sudo access
echo "Granting sudo access to dennis..."
sudo usermod -aG sudo dennis

# Final confirmation
echo "Script execution completed successfully!"
