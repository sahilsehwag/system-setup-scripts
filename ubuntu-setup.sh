#! /bin/bash

#VARIABLES
	#LOCATIONS
		DOTFILES="https://raw.githubusercontent.com/sahilsehwag/dotfiles/master"
		CLOUD=""
	#COLORS
		NC='\033[0m'
	VERBOSE=$1
#SETUP
	! type curl     &> /dev/null && sudo apt-get -y install curl
	! type git      &> /dev/null && sudo apt-get -y install git
	! type automake &> /dev/null && sudo apt-get -y install automake
	! type python3  &> /dev/null && sudo apt-get -y install python3
	! type pip3     &> /dev/null && sudo apt-get -y install python3-pip
	! type python3  &> /dev/null && sudo apt-get -y install python3-dev
#HELPERS
	#COLOR
		function color()
		{
			if [[ $# -eq 1 ]]; then
				style=$(echo $1 | cut -d: -f1)
				fgc=$(echo $1 | cut -d: -f2)
				bgc=$(echo $1 | cut -d: -f3)

				code=\\033\[

				if [[ ! -z $style ]]; then
					if [[ $style =~ BOLD ]]; then
						code=$code"1;"
					elif [[ $style =~ FAINT ]]; then
						code=$code"2;"
					elif [[ $style =~ ITALIC ]]; then
						code=$code"3;"
					elif [[ $style =~ UNDERLINE ]]; then
						code=$code"4;"
					elif [[ $style =~ CONCEAL ]]; then
						code=$code"8;"
					elif [[ $style =~ CROSSED ]]; then
						code=$code"9;"
					fi
				else
					code=$code"0;"
				fi

				if [[ ! -z $fgc ]]; then
					if [[ $fgc =~ BLACK ]]; then
						code=$code"30;"
					elif [[ $fgc =~ RED ]]; then
						code=$code"31;"
					elif [[ $fgc =~ GREEN ]]; then
						code=$code"32;"
					elif [[ $fgc =~ YELLOW ]]; then
						code=$code"33;"
					elif [[ $fgc =~ BLUE ]]; then
						code=$code"34;"
					elif [[ $fgc =~ MAGENTA ]]; then
						code=$code"35;"
					elif [[ $fgc =~ CYAN ]]; then
						code=$code"36;"
					elif [[ $fgc =~ GRAY ]]; then
						code=$code"37;"
					fi
				else
					code=$code"39;"
				fi

				if [[ ! -z $bgc ]]; then
					if [[ $bgc =~ BLACK ]]; then
						code=$code"40"
					elif [[ $bgc =~ RED ]]; then
						code=$code"41"
					elif [[ $bgc =~ GREEN ]]; then
						code=$code"42"
					elif [[ $bgc =~ YELLOW ]]; then
						code=$code"43"
					elif [[ $bgc =~ BLUE ]]; then
						code=$code"44"
					elif [[ $bgc =~ MAGENTA ]]; then
						code=$code"45"
					elif [[ $bgc =~ CYAN ]]; then
						code=$code"46"
					elif [[ $bgc =~ GRAY ]]; then
						code=$code"47"
					fi
				else
					code=$code"49"
				fi

				code=$code"m"
				echo $code
			fi
		}
	#LOGGING
		function log::log()
		{
			echo -e $(color BOLD::)LOG: $* $NC
		}
		function log::debug()
		{
			echo -e $(color BOLD:BLACK:GRAY)DEB: $*$NC
		}
		function log::success()
		{
			echo -e $(color BOLD:GREEN:)SUC: $* $NC
		}
		function log::error()
		{
			echo -e $(color BOLD:RED:)ERR: $* $NC
		}
		function log::warning()
		{
			echo -e $(color BOLD:YELLOW:)WAR: $* $NC
		}
		function log::info()
		{
			echo -e $(color BOLD:BLUE:)INF: $* $NC
		}
#PACKAGES
	#UTILITIES
		function utils::install()
		{
			! type ag        > /dev/null && sudo apt-get -y install silversearcher-ag
			! type ack       > /dev/null && sudo apt-get -y install ack-grep
			! type pandoc    > /dev/null && sudo apt-get -y install pandoc
			! type readline  > /dev/null && sudo apt-get -y install readline
			! type fuck      > /dev/null && sudo pip3 install thefuck
			#! type cheat     > /dev/null && sudo pip3 install cheat
			! type tree      > /dev/null && sudo apt-get install tree
			! type dos2unix  > /dev/null && sudo apt-get install dos2unix
			! type htop      > /dev/null && sudo apt-get install htop
			! type highlight > /dev/null && sudo apt-get install highlight
			! type ctags     > /dev/null && sudo apt-get install ctags

			#jq
			#exa
			if ! type exa > /dev/null; then
				! type cargo > /dev/null && rust::install
				cargo install exa
			fi

			#path-extractor
			if ! type path-extractor > /dev/null; then
				if ! type go > /dev/null; then
					go::install
					go::path
				fi
				sudo go get https://github.com/edi9999/path-extractor
			fi
		}
	#TUIs
		#ZSH
			function zsh::dotfile()
			{
				if  [[ ! -f  $HOME/.zshrc ]]; then
					curl "$DOTFILES"/.zshrc > $HOME/.zshrc
				fi
			}

			function zsh::ohmyzsh()
			{
				[[ ! -d $HOME/.oh-my-zsh ]] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
			}

			function zsh::install()
			{
				! type "zsh" > /dev/null && sudo apt-get -y install zsh
			}

			function zsh::uninstall()
			{
				if type "zsh" > /dev/null; then
					sudo apt-get -y remove zsh
					[[ -f $HOME/.zshrc ]] && sudo rm $HOME/.zshrc
				fi
			}
		#TMUX
			function tmux::dotfile()
			{
				if [[ ! -f  $HOME/.tmux.conf ]]; then
					curl "$DOTFILES"/.tmux.conf > $HOME/.tmux.conf
				fi
			}

			function tmux::aliases()
			{
				[[ ! -d $HOME/aliases ]]       && mkdir $HOME/aliases
				[[ ! -f $HOME/aliases/.tmux ]] && curl "$DOTFILES"/aliases/.tmux > $HOME/aliases/.tmux
			}

			function tmux::pacman()
			{
				if [[ $(tmux -V | cut -d' ' -f2) > 1.9 ]] && ! -d $HOME/.tmux/plugins/tpm; then
					git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
					[[ -f $HOME/.tmux.conf ]] && tmux source $HOME/.tmux.conf
				fi
			}

			function tmux::install()
			{
				! type "tmux" > /dev/null && sudo apt-get -y install tmux
			}
			function tmux::uninstall()
			{
				if type "zsh" > /dev/null; then
					sudo apt-get -y remove tmux
					[[ -f $HOME/.tmux.conf ]]     && sudo rm $HOME/.tmux.conf
					[[ -f $HOME/.aliases/.tmux ]] && sudo rm $HOME/aliases/.tmux
				fi
			}
		#NVIM
			function nvim::dotfile()
			{
				if [[ ! -f  $HOME/.config/nvim/init.vim ]]; then
					if [[ ! -d $HOME/.config/nvim ]]; then
						mkdir -p $HOME/.config/nvim
					fi
					curl "$DOTFILES"/init.vim > $HOME/.config/nvim/init.vim
				fi
			}

			function nvim::pacman()
			{
				#vim-plug
				if [[ ! -f  $HOME/.local/share/nvim/site/autoload/plug.vim ]]; then
					curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
						https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
				fi
			}

			function nvim::install()
			{
				if ! type "nvim" > /dev/null; then
					sudo apt-get -y install python3-dev
					sudo apt-get -y install software-properties-common
					sudo add-apt-repository ppa:neovim-ppa/stable
					sudo apt-get -y update
					sudo apt-get -y install neovim
					sudo pip3 install neovim
				fi
			}
			function nvim::uninstall()
			{
				if type "nvim" > /dev/null; then
					sudo apt-get -y remove neovim
				fi
				sudo pip3 uninstall neovim
				[[ -d $HOME/.config/nvim ]]      && sudo rm -rf $HOME/.config/nvim
				[[ -d $HOME/.local/share/nvim ]] && sudo rm -rf $HOME/.local/share/nvim
			}
		#FZF
			function fzf::aliases()
			{
				[[ ! -d $HOME/aliases ]] && mkdir $HOME/aliases
				curl "$DOTFILES"/aliases/.fzf > $HOME/aliases/.fzf
			}

			function fzf::install()
			{
				! type "fzf" > /dev/null \
				&& [[ ! -d $HOME/.fzf ]] \
				&& git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
				$HOME/.fzf/install
			}

			function fzf::uninstall()
			{
				sudo rm -rf $HOME/.fzf
				sudo rm $HOME/aliases/.fzf
			}
		#VIFM
			function vifm::dotfile()
			{
				[[ ! -f $HOME/.vifm/vifmrc ]] && curl "$DOTFILES"/vifmrc > $HOME/.vifm/vifmrc
			}

			function vifm::install()
			{
				if ! type "vifm" > /dev/null; then
					sudo apt-get -y install build-essential
					sudo apt-get -y install libncursesw5-dev
					sudo apt-get -y install sshfs curlftpfs fuse fuse-zip fusefat fuseiso
					sudo apt-get -y install intltool

					if [[ ! -d $HOME/vifm ]]; then
						git clone https://github.com/vifm/vifm $HOME/vifm
					fi

					cd $HOME/vifm
					sudo $HOME/vifm/configure
					sudo make
					sudo make install
				fi
			}

			function vifm::uninstall()
			{
				if type vifm &> /dev/null; then
					cd $HOME/vifm && sudo make uninstall
				fi
				[[ -d $HOME/vifm ]]  && sudo rm -rf $HOME/vifm
				[[ -d $HOME/.vifm ]] && sudo rm -rf $HOME/.vifm
			}
		#FASD
			function fasd::aliases()
			{
				[[ ! -d $HOME/aliases ]] && mkdir $HOME/aliases
				[[ ! -f $HOME/.fasd ]]   && curl "$DOTFILES"/aliases/.fasd > $HOME/.fasd
			}

			function fasd::install()
			{
				[[ ! -d $HOME/fasd ]] && git clone https://github.com/clvv/fasd $HOME/fasd
				cd $HOME/fasd && make install
			}

			function fasd::uninstall()
			{
				[[ -d $HOME/fasd ]]          && sudo rm -rf $HOME/fasd
				[[ -f $HOME/aliases/.fasd ]] && sudo rm $HOME/aliases/.fasd
			}
		#EMACS
		#SPACEMACS
	#GUIs
	#DEVELOPMENT
		#DATABASES
			#function sqlite::install(){}
			#function sqlite::uninstall(){}
			#function mysql::install(){}
			#function mysql::uninstall(){}
			#function mongodb::install(){}
			#function mongodb::uninstall(){}
		#LANGUAGES
			#PYTHON
				function python::install()
				{
					if [[ $1 =~ 3 ]]; then
						! type python3 > /dev/null && sudo apt-get -y install python3
						! type pip3 > /dev/null    && sudo apt-get -y install python3-pip
					else
						! type python3 > /dev/null && sudo apt-get -y install python3
						! type pip3 > /dev/null    && sudo apt-get -y install python3-pip
					fi
				}

				function python::uninstall()
				{
					type python3 > /dev/null && sudo apt-get -y remove python3
				}

				function anaconda::install()
				{
					if [[ $1 =~ 3 ]]; then
						[[ ! -f $HOME/anaconda.sh ]] && curl https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh > $HOME/anaconda.sh
						sudo sh $HOME/anaconda.sh
					else
						[[ ! -f $HOME/anaconda.sh ]] && curl https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh > $HOME/anaconda.sh
						sudo sh $HOME/anaconda.sh
					fi
				}

				#function anaconda::path(){}

				function anaconda::uninstall()
				{
					[[ -f $HOME/anaconda.sh ]] && sudo rm anaconda.sh
				}

				#function python::libs(){}
				#function python::utils(){}
			#NODEJS
				function node::install()
				{
					if ! type "node" > /dev/null; then
						sudo apt-get install build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev gcc
						curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
						sudo apt-get install -y nodejs
					fi
				}

				function node::uninstall()
				{
					type "node" > /dev/null && sudo apt-get remove -y nodejs
				}

				#function node::libs(){}
				function node::utils()
				{
					if [[ $1 =~ web ]]; then
						sudo npm install -g nodemon
					fi
				}
			#RUST
				function rust::path()
				{
					echo 'export PATH=$PATH:$HOME/.cargo/bin' >> $HOME/.profile
				}

				function rust::install()
				{
					sudo curl https://sh.rustup.rs -sSf | sh
				}

				function rust::uninstall()
				{
					type rustup > /dev/null && rustup self uninstall
				}
			#GO
				function go::path()
				{
					echo 'export PATH=/usr/local/go/bin:$PATH'    >> $HOME/.profile
					echo 'export PATH=$HOME/.config/go/bin:$PATH' >> $HOME/.profile
					echo 'export GOPATH=$HOME/.config/go'         >> $HOME/.profile
					echo 'export GOROOT=/usr/local/go'            >> $HOME/.profile
				}

				function go::install()
				{
					if [[ $# -eq 2 ]]; then
						gov=$1
						arch=$2
					else
						gov=1.9.1
						arch=amd64
					fi
					sudo curl -O https://storage.googleapis.com/golang/go$gov.linux-$arch.tar.gz
					sudo tar -xvf go$gov.linux-$arch.tar.gz
					sudo mv go /usr/local
				}

				function go::uninstall()
				{
					[[ -d /usr/local/go ]] && sudo rm -rf /usr/local/go
				}
			#JAVA
				#@TEST
				function java::install()
				{
					if ! type java > /dev/null; then
						if [[ $# -ge 1 ]]; then
							if [[ $1 =~ default ]]; then
								sudo apt-get install default-jdk
							elif [[ $1 =~ latest ]]; then
								sudo apt-get install software-properties-common
								sudo add-apt-repository ppa:webupd8team/java
								if [[ $# -eq 2 ]]; then
									JAVA_VERSION=$2
								else
									JAVA_VERSION=9
								fi
								sudo apt-get install oracle-java$JAVA_VERSION-installer
							elif [[ $1 =~ manual ]]; then
								sudo wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz
								sudo mkdir /opt/java
								tar -zxf jdk-9.0.4_linux-x64_bin.tar.gz -C /opt/java
							elif [[ $1 =~ help ]]; then
								echo "ARGUMENT: default|latest|manual|help"
							fi
						fi
					fi
				}

				#function java::uninstall(){}
	#FONTS
		function fonts::poweline()
		{
			sudo apt-get install fonts-powerline
		}

		#function fonts:nerd(){}
#CONFIGURATION
	#function profile::dotfile(){}
	#function enviornment::dotfile(){}
#SCHEMES
	#function install::install(){}
	#function uninstall::uinstall(){}
	#function install::minimal(){}
	#function uninstall::minimal(){}
