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

To check if MongoDB is running, run the following command:

```bash
brew services list
or
mongosh
```

10. Other nuances and quirks to be aware of:

- Turn of the Keyboard Shortcut for Spotlight by going to System Preferences > Keyboard > Shortcuts > Spotlight and unchecking the `Show Spotlight Search` and `Show Finder Search Window` options. Reason to use `⌘ + Space` for Raycast.
- Import the **Raycast** Config from this dir by going to Raycast > Settings > Import/Export > Import and selecting the `raycast.rayconfig` file.
- Install [Hidden Bar](https://apps.apple.com/in/app/hidden-bar/id1452453066?mt=12), [AnySwitch](https://apps.apple.com/in/app/anyswitch-powerful-switches/id6444313776?mt=12) and [One Thing](https://apps.apple.com/in/app/one-thing/id1604176982?mt=12) via Apple App Store (Now available on brew)
- Import Passwords to Arc Browser profile.
- Set Mouse to **Natural Scrolling** by going to System Preferences > Mouse > Scroll Direction: Natural.
- Turn on **Path Bar** and **Status Bar** in Finder by going to View > Show Path Bar and View > Show Status Bar.
- In Settings > Control Center, Under **Control Center Modules**: Change Display, Sound, Focus to _Always Show in Menu Bar_. Under **Other Modules**: Turn on `Show Percentage` for Battery and `Show in Control Center` for Keyboard Brightness. Under **Menu Bar Only** Change Spotlight `Don't Show in Menu Bar` and For Weather, Change `Show in Menu Bar`.
- Make sure to uncheck the option - `Open at Login`, for the apps which I don't want to run at startup. Like Warp, Canva, Docker, etc.

### Steps to Update or Create the Brewfile

```bash
brew bundle dump --describe --file ~/.dotfiles/Brewfile
```

If the Brewfile already exists, the above command will overwrite it. If you want to append to the existing Brewfile, use the following command:

```bash
brew bundle dump --describe --file ~/.dotfiles/Brewfile --force
```

### Setting up a GPG Key for signing commits

Follow the steps mentioned in the link below to setup a GPG key for signing commits.
https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key

After setting up to sign commits, run the following commands to configure git to sign all commits by default.

```bash
git config --global user.signingkey <GPG Key ID>
git config --global commit.gpgsign true
```

### Security

If you discover any security related issues, please check the [security policy](SECURITY.md) for more information.