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

8. Create symlinks for the zshrc file.

```bash
ln -s ~/.dotfiles/.zshrc ~/.zshrc
```

9. Install zsh-autosuggestions extension.

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

10. Start MongoDB and set it to launch at startup. [Docs for reference](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/)

```bash
brew services start mongodb-community
```

To check if MongoDB is running, run the following command:

```bash
brew services list
or
mongosh
```

11. Other nuances and quirks to be aware of:

- **Enable App Management permissions** so Homebrew can delete and reinstall apps.  
  - Go to **Settings > Privacy & Security > App Management** and add or enable your terminal.  

- **Disable the Keyboard Shortcut for Spotlight** to free up `⌘ + Space` for **Raycast**.  
  - Go to **System Preferences > Keyboard > Shortcuts > Spotlight** and uncheck:  
    - `Show Spotlight Search`  
    - `Show Finder Search Window`  

- **Import the Raycast config** from this directory:  
  - **Raycast > Settings > Import/Export > Import** and select `raycast.rayconfig`.  

- **Install apps from the App Store (also available on Homebrew):**  
  - [Hidden Bar](https://apps.apple.com/in/app/hidden-bar/id1452453066?mt=12)  
  - [AnySwitch](https://apps.apple.com/in/app/anyswitch-powerful-switches/id6444313776?mt=12)  
  - [One Thing](https://apps.apple.com/in/app/one-thing/id1604176982?mt=12)   

- **Set Mouse Scrolling to Natural:**  
  - **System Preferences > Mouse > Scroll Direction: Natural**  

- **Enable Path Bar and Status Bar in Finder:**  
  - **View > Show Path Bar**  
  - **View > Show Status Bar**  

- **Adjust Control Center settings:**  
  - **Settings > Control Center**  
    - **Control Center Modules:** Set **Display, Sound, and Focus** to _Always Show in Menu Bar_.  
    - **Other Modules:**  
      - Enable `Show Percentage` for **Battery**.  
      - Enable `Show in Control Center` for **Keyboard Brightness**.  
    - **Menu Bar Only:**  
      - Hide **Spotlight** (`Don't Show in Menu Bar`).  
      - Show **Weather** (`Show in Menu Bar`).  

- **Disable startup apps:**  
  - Go to **System Preferences > General > Login Items and Extensions**.  
  - Uncheck apps like **Warp, Canva, Docker**, etc.  

- **Set Trackpad settings:**  
  - **Tap to Click:** **System Preferences > Trackpad > Point & Click > Tap to Click**.  
  - **Secondary Click:** **Click in bottom right corner**.  

- **Arc Browser Settings:**  
  - **Enable Sync Sidebar**.  
  - Install [iCloud Passwords](https://chromewebstore.google.com/detail/pejdijmoenmkgeppbflobdenhhabjlaj?utm_source=item-share-cb) from the **Arc Browser extension store**.  
  - **Under Links:** Turn off `Links from other apps open in Little Arc`.  
  - **Under Max:** Enable **Max Mode**.  

- **Install GenCLI** with `go install github.com/Pradumnasaraf/gencli@latest`.

- **Install Grammarly Extension** for [Arc Browser.](https://chromewebstore.google.com/detail/kbfnbcaeplbcioakkpcpgfkobkghlhen?utm_source=item-share-cb)

- **Set Hot Corners:**  
  - **System Preferences > Mission Control > Hot Corners**.  
    - **Top Right:** **Notification Center**.

- **iCloud Desktop and Documents sync:**  
  - **System Preferences > Apple ID > iCloud > Drive**
    - Enable **Desktop & Documents Folders**.

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