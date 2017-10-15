#! /bin/sh

#VARIABLES
	DRIVE=~/Google\ Drive
#HOMEBREW
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew tap caskroom/cask
#SETUP
	brew install git
	brew install wget
	brew install curl
#DEVELOPMENT
	brew install python3
	brew install node
	brew install go
#CLI
	#UTILITIES
		brew install fasd
		brew install dos2unix
		brew install readline
		brew install ag
		brew install ack
	#NVIM
		brew install neovim
	#ZSH
		brew install zsh
	#TMUX
		brew install tmux
	#FZF
		brew install fzf
	#VIFM
		brew install vifm
#GUI
	brew cask install iterm2
	brew cask install alfred
	brew cask install google-backup-and-sync
	brew cask install visual-studio-code
	brew cask install google-chrome
	brew cask install spotify
	brew cask install cleanmymac
	brew cask install whatsapp
	brew cask install bittorrent
	brew cask install vlc
	brew cask install shimo
	#brew cask install macvim
	#brew cask install foldingtext
