# dotfiles

## Decommission Previous Computer (if possible)

Assuming you're not dealing with a theft or drive failure, do what you can to backup files and deactivate licenses.

Backup / sync everything:

- Commit and Push to remote repositories
- Run npkill and clean all node_module folders
- Run `code --list-extensions > vscode_extensions` from `~/.dotfiles` to export [VS Code extensions](vscode_extensions)
- Run `mackup backup`
- Export Xcode certificates with private and public key
- Take a screenshot of the dock icons and Finder favorites
- Backup User folder
- Backup Obsidian

Deactivate licenses:

- Dropbox (`Preferences > Account > Unlink`)

[Create a bootable USB installer for macOS](https://support.apple.com/en-us/HT201372).

## Restore Instructions

1. Install Xcode from Mac App Store
2. `xcode-select --install`. We need this for `git`, among other things. (if stuck on "Finding Software" install it [manually](https://developer.apple.com/download/more/))
3. `git clone https://github.com/erodriguezh/dotfiles ~/dotfiles`. We'll start with `https` but switch to `ssh` after everything is installed.
4. `cd ~/dotfiles`
5. `./install`
6. Restart computer.
7. Setup up Dropbox (use multifactor authentication!) and allow files to sync before setting up dependent applications. Mackup depends on this (and thus so do Terminal and VS Code).
8. `mackup restore`. Consider doing a `mackup restore --dry-run --verbose` first.
9. Skip if ssh synched with Mackup: [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh), add to github, and switch remotes

    ```zsh
    # Generate SSH key in default location (~/.ssh/config)
    ssh-keygen -t rsa -b 4096 -C "erodriguezh@users.noreply.github.com"

    # Start the ssh-agent
    eval "$(ssh-agent -s)"

    # Create config file with necessary settings
    << EOF > ~/.ssh/config
    Host *
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_rsa
    EOF

    # Add private key to ssh-agent 
    ssh-add -K ~/.ssh/id_rsa

    # Copy public key and add to github.com > Settings > SSH and GPG keys
    pbcopy < ~/.ssh/id_rsa.pub

    # Test SSH connection, then verify fingerprint and username
    # https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection
    ssh -T git@github.com
    ```

10. Switch from HTTPS to SSH `cd ~/dotfiles && git remote set-url origin git@github.com:erodriguezh/dotfiles.git`

### Manual Steps

#### SSH

1. Copy both id_rsa and id_rsa.pub to ~/.ssh/
2. Change file permissions and ownership of both files
  
    ```zsh
    chown user:user ~/.ssh/id_rsa*
    chmod 600 ~/.ssh/id_rsa
    chmod 644 ~/.ssh/id_rsa.pub
    ```

3. Start the ssh-agent. `exec ssh-agent bash`
4. Add your SSH private key to the ssh-agent. `ssh-add ~/.ssh/id_rsa`

#### Nativescript

1. Open Android Studio and install tools reccommended, install 1 emulator and intall command line tools
2. Run Nativescript installation: `cd ~/dotfiles && ./setup-nativescript.zsh`

#### Files & Finder

1. Restore folders: Downloads, Documents, Developer, Movies
2. Arrange dock icon as shown in screenshot
3. Arrange Finder Favorites as shown in screenshot

#### Chrome

1. Restore Google Chrome Sync

#### Dev Certificates

1. Install Xcode certificates
