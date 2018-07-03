#! /bin/bash
#DEPENDENCIES
#VARIABLES
	DOTFILES="https://raw.githubusercontent.com/sahilsehwag/dotfiles/master"
#ENVIORNMENT
#SETUP
	! type curl     &> /dev/null && sudo apt-get -y install curl
	! type git      &> /dev/null && sudo apt-get -y install git
	! type automake &> /dev/null && sudo apt-get -y install automake
	! type python3  &> /dev/null && sudo apt-get -y install python3
	! type pip3     &> /dev/null && sudo apt-get -y install python3-pip
#UTITLITIES
	#ZSH
		if [[ $@ ~= zsh.install || $@ ~= complete.install ]]; then
			if ! type "zsh" > /dev/null; then
				sudo apt-get -y install zsh
				sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

				if  [[ ! -f  ~/.zshrc ]]; then
					curl "$DOTFILES"/.zshrc >> ~/.zshrc
				fi
			fi
		elif [[ $@ ~= zsh.uninstall || $@ ~= complete.uninstall ]]; then
			sudo apt-get remove zsh
			sudo rm ~/.zshrc
		fi
	#TMUX
		if [[ $@ ~= tmux.install || $@ ~= complete.install ]]; then
			if ! type "tmux" > /dev/null; then
				sudo apt-get -y install tmux
				if [[ ! -d ~/.tmux/plugins/tpm ]]; then
					git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
				fi
				if [[ ! -f  ~/.tmux.conf ]]; then
					curl "$DOTFILES"/.tmux.conf >> ~/.tmux.conf
					curl --create-dirs "$DOTFILES"/aliases/.tmux >> ~/aliases/.tmux
				fi
			fi
		elif [[ $@ ~= tmux.uninstall || $@ ~= complete.uninstall ]]; then
			sudo apt-get remove tmux
			sudo rm ~/.tmux.conf
			sudo rm ~/aliases/.tmux
		fi
	#FZF
		if [[ $@ ~= fzf.install || $@ ~= complete.install ]]; then
			if ! type "fzf" > /dev/null; then
				if [[ ! -d ~/.fzf ]]; then
					git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
				fi
				~/.fzf/install
			fi
			curl --create-dirs "$DOTFILES"/aliases/.fzf >> ~/aliases/.fzf
		elif [[ $@ ~= fzf.uninstall || $@ ~= complete.uninstall ]]; then
			sudo rm -rf ~/.fzf
			sudo rm ~/aliases/.fzf
		fi
	#NEOVIM
		if [[ $@ ~= nvim.install || $@ ~= complete.install ]]; then
			if ! type "nvim" > /dev/null; then
				sudo apt-get -y install python3-dev
				sudo apt-get -y install software-properties-common
				sudo add-apt-repository ppa:neovim-ppa/stable
				sudo apt-get -y update
				sudo apt-get -y install neovim
				sudo pip3 install neovim
			fi

			#VIM-PLUG
			if [[ ! -f  ~/.local/share/nvim/site/autoload/plug.vim ]]; then
				curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
					https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
			fi
			if [[ ! -f  ~/.config/nvim/init.vim ]]; then
				curl --create-dirs "$DOTFILES"/init.vim >> ~/.config/nvim/init.vim
			fi
		elif [[ $@ ~= nvim.uninstall || ~= complete.uninstall ]]; then
			sudo apt-get uninstall neovim
			sudo pip3 uninstall neovim
			sudo rm -rf ~/.config/nvim
			sudo rm -rf ~/.local/share/nvim
		fi
	#VIFM
		if [[ $@ ~= vifm.install || $@ ~= complete.install ]]; then
			if ! type "vifm" > /dev/null; then
				sudo apt-get -y install build-essential
				sudo apt-get -y install libncursesw5-dev
				sudo apt-get -y install sshfs curlftpfs fuse fuse-zip fusefat fuseiso
				sudo apt-get -y install intltool

				if [[ ! -d ~/vifm ]]; then
					git clone https://github.com/vifm/vifm ~/vifm
				fi

				cd ~/vifm
				sudo ~/vifm/configure
				sudo make
				sudo make install
				curl "$DOTFILES"/vifmrc >> ~/.vifm/vifmrc
			fi
		elif [[ $@ ~= vifm.uninstall || ~= complete.uninstall ]]; then
			cd ~/vifm && sudo make uninstall
			sudo rm -rf ~/vifm
			sudo rm -rf ~/.vifm
		fi
	#FASD
		if [[ $@ ~= fasd.install || $@ ~= complete.install ]]; then
			if [[ ! -d ~/fasd ]]; then
				git clone https://github.com/clvv/fasd ~/fasd
			fi
			cd ~/fasd && make install
			curl "$DOTFILES"/aliases/.fasd >> ~/.fasd
		elif [[ $@ ~= fasd.uninstall || $@ ~= complete.uninstall ]]; then
			sudo rm -rf ~/fasd
			sudo rm ~/aliases/.fasd
		fi
	#EMACS
	#SPACEMACS
#APPLICATIONS
#DEVELOPMENT
	#DATABASES
	#LANGUAGES
		#PYTHON
			#ANACONDA
				if [[ $@ ~= anaconda.install || $@ ~= complete.install ]]; then
					if [[ ! -f ~/anaconda.sh ]]; then
						curl https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh >> ~/anaconda.sh
					fi
					sudo bash ~/anaconda.sh
				elif [[ $@ ~= anaconda.uninstall || $@ ~= complete.uninstall ]]; then
					sudo rm anaconda.sh
				fi
			#LIBRARIES
		#NODE
	#SOFTWARES
