#! /bin/bash

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
	#BUILD
		#DEPENDENCIES
		brew install cmake
		brew install gcc
		brew install mono
	#LANGUAGES
		brew install python3
		brew install node
		brew install go
		brew install r
		brew install rust
		brew install lua
		brew install haskell-stack
		brew cask install java
		brew cask install processing
	#PACKAGE MANAGERS
	#DATABASES
		brew install sqlite
	#INTERACTIVE
		brew install jupyter
		brew install ipython
		brew install cling
		brew install chaiscript
		brew install ghc
		brew install javarepl
#CLI
	#UTILITIES
		brew install reattach-to-user-namespace
		brew install dos2unix
		brew install readline
		brew install ag
		brew install ack
		brew install pandoc
		brew install tree
		brew install highlight
		brew install ctags
		brew install jq
		brew install htop
		brew install exa
		brew install cheat
		brew install thefuck
		brew install path-extractor
		#brew install dasht
	#MISCELLANOUS
		brew install figlet
	#APPLICAITONS
		brew install fasd
		brew install neovim
		brew install zsh
		brew install tmux
		brew install fzf
		brew install vifm
		brew install task
		brew install cmus
		#VIS EDITOR
			brew install libtermkey
			brew install ncurses
			brew install lua
			brew install tre
			sudo luarocks install lpeg
			cd ~
			git clone https://github.com/martanne/vis
			cd ~/vis
			./configure && make && sudo make install
			cd ../
			rm -rf ~/vis
#GUI
	brew cask install iterm2
	brew cask install dash
	brew cask install alfred
	brew cask install google-backup-and-sync
	brew cask install google-chrome
	brew cask install spotify
	brew cask install cleanmymac
	brew cask install whatsapp
	brew cask install bittorrent
	brew cask install vlc
	brew cask install oni
	brew cask install emacs
	brew cask install numi
	brew cask install torbrowser
	#brew cask install keycastr
	#brew cask install macvim
	#brew cask install foldingtext
	#brew cask install visual-studio-code
#LIBRARIES|FRAMEWORKS
	#PYTHON
	#GO
	#LUA
	#NODE
