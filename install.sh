#!/bin/bash

# Update package lists
sudo apt-get update && sudo apt-get upgrade -y

# Install necessary packages
sudo apt-get install -y curl git vim zsh nano fzf direnv bat gpg

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Set Zsh theme
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/g' ~/.zshrc
echo '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.' >> ~/.zshrc
echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

# Copy theme file if not exists
if [ ! -f ~/.p10k.zsh ]; then
    cp p10k.zsh ~/.p10k.zsh
fi

# Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Set Zsh plugins
sed -i 's/plugins=(git)/plugins=(git git-extras docker docker-compose ubuntu zsh-autosuggestions zsh-syntax-highlighting fzf)/g' ~/.zshrc

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER

# Install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
# Set Zsh completions
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

# Set Zsh keybindings
# echo 'bindkey "^T" fzf-cd-widget' >> ~/.zshrc
echo 'bindkey  "^[[H"   beginning-of-line' >> ~/.zshrc
echo 'bindkey  "^[[F"   end-of-line' >> ~/.zshrc
echo 'bindkey  "^[[3~"  delete-char' >> ~/.zshrc

# Print installation complete message
echo "Installation complete!"
