#!/bin/bash -e

# install cask and tap versions
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

# browsers
brew cask install google-chrome
brew cask install firefox
brew cask install opera

# daily
brew cask install alfred

# development
brew cask install iterm2
# brew cask install phpstorm - disabled until the version with custom jdk is available through cask
brew cask install imagealpha
brew cask install imageoptim
brew cask install filezilla
brew cask install virtualbox

# communication
brew cask install skype
brew cask install slack

# others
brew cask install spotify
brew cask install qbittorrent
brew cask install vlc

# additional - not needed at install
# brew cask install atom
# brew cask install brackets
# brew cask install visual-studio-code