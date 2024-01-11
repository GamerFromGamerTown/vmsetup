# Update package list
sudo apt update

# Install necessary tools
sudo apt install curl git

# Add Brave browser repository and key
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Update package list again after adding new repository
sudo apt update

# Install Brave browser, Sway, PCManFM, Alacritty, Rofi, and Neofetch
sudo apt install brave-browser sway pcmanfm alacritty rofi neofetch

# Compiling ly
git clone --recurse-submodules https://github.com/nullgemm/ly.git
cd ly
make -j2
make install

# Configure Sway for user 'vm'
VM_HOME=$(getent passwd "vm" | cut -d: -f6)
mkdir -p "$VM_HOME/.config/sway"
cp /etc/sway/config "$VM_HOME/.config/sway/config"
echo "exec brave-browser" >> "$VM_HOME/.config/sway/config"
echo 'bindsym $mod+r exec rofi -show run' >> "$VM_HOME/.config/sway/config"
chown -R vm:vm "$VM_HOME/.config/sway"

# Configure Ly for autologin
sed -i 's/# auto_login = false/auto_login = true/' /etc/ly/config.ini
sed -i 's/# auto_username =/auto_username = vm/' /etc/ly/config.ini
sed -i 's/# auto_wayland = sway/auto_wayland = sway/' /etc/ly/config.ini

# Enable Ly display manager
sudo systemctl enable ly
# make windows + r = rofi (app launcher)
echo 'bindsym $mod+r exec rofi -show run' >> ~/.config/sway/config
sudo apt remove git
