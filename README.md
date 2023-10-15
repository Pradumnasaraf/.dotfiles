# .dotfiles

This repository contains my dotfiles for Pradumnasaraf's macOS setup.

### Steps to setup a new mac

1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

```bash
xcode-select --install
```

2. Clone repo into new hidden directory.

```bash
git clone https://github.com/Pradumnasaraf/.dotfiles.git ~/.dotfiles
```

3. Create symlinks in the Home directory to the real files in the repo.

```bash
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.zprofile ~/.zprofile
ln -s ~/.dotfiles/.zshrc ~/.zshrc
```

4. Install Homebrew, followed by the software listed in the Brewfile.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

5. Add Homebrew's installed location to your `$PATH` in `~/.zprofile`:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

6. Install all the software in the Brewfile located in the root of this repo.

```bash
brew bundle --file ~/.dotfiles/Brewfile
```

7. Install Oh My Zsh.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

8. Install zsh-autosuggestions extension.

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

9. Start MongoDB and set it to launch at startup. [Docs for reference](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/)

```bash
brew services start mongodb-community
```

### Steps to Update or Create the Brewfile

```bash
brew bundle dump --describe --file ~/.dotfiles/Brewfile
```

## Security

If you discover any security related issues, please check the [security policy](SECURITY.md) for more information.