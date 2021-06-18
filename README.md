# dotfiles

## Decommission Previous Computer (if possible)

Assuming you're not dealing with a theft or drive failure, do what you can to backup files and deactivate licenses.

Backup / sync everything:

1. Run `mackup backup`
2. Export Xcode certificates with private and public key
3. Take a screenshot of the dock icons
4. Run npkill and clean all node_module folders
5. Backup User folder
6. Backup Obsidian

## Restore Instructions

1. `xcode-select --install`. We need this for `git`, among other things.
2. `git clone https://github.com/erodriguezh/dotfiles ~/.dotfiles`. We'll start with `https` but switch to `ssh` after everything is installed.
3. `cd ~/.dotfiles`
4. `source install`
5. Restart computer.
6. `mackup restore`, might want to do `--dry-run` first
7. Skip if ssh synched with Mackup: [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh), add to github, and switch remotes

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

    # Switch from HTTPS to SSH
    git remote set-url origin git@github.com:erodriguezh/dotfiles.git
    ```

### Manual Steps

1. Restore User folder
2. Arrange dock icon as shown in screenshot
3. Install Xcode certificates
