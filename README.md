# dotfiles

## Installation

```bash
# install command line utilites to get access to git
xcode-select --install

# install homebrew (https://brew.sh)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install yadm
brew install yadm

# clone this repository, accept prompt to run bootstrap script
yadm clone git@github.com:ErikMLutz/dotfiles.git

# opening a new shell and running the following will be necessary a few times
# so that installs that have dependencies on previous installs can bootstrap
yadm bootstrap
```

After getting everything installed via the command line:

1. Open Karabiner Elements and follow it's prompts to give it permission to remap keys
1. Log out and log back in for Mac settings to take effect

and also

```bash
# configure git depending on what machine this is
git config --global user.name "<name>"
git config --global user.email "<email>"
```
