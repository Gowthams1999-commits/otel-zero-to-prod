#!/bin/bash

# Install gnupg and wget (if not installed):
sudo apt update

# Create the keyrings directory:
sudo apt install -y gnupg wget


# Download the correct Jenkins key and convert it to .gpg:
sudo mkdir -p /etc/apt/keyrings

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor | sudo tee /etc/apt/keyrings/jenkins.gpg > /dev/null


echo "deb [signed-by=/etc/apt/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list


sudo apt update
sudo apt install -y jenkins


sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins

