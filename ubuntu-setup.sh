#! /bin/bash
#https://github.com/sahilsehwag

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
			echo -e $(color BOLD::)LOG::$(color ::)$* $NC
		}
		function log::debug()
		{
			echo -e $(color BOLD::)DEB::$(color :BLACK:GRAY)$*$NC
		}
		function log::success()
		{
			echo -e $(color BOLD::)SUC::$(color :GREEN:)$* $NC
		}
		function log::error()
		{
			echo -e $(color BOLD::)ERR::$(color :RED:)$* $NC
		}
		function log::warning()
		{
			echo -e $(color BOLD::)WAR::$(color :YELLOW:)$* $NC
		}
		function log::info()
		{
			echo -e $(color BOLD::)INF::$(color :BLUE:)$* $NC
		}
#PACKAGES
	#UTILITIES
		function utilities::exa()
		{
			if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
				cargo uninstall exa
			else
				if ! type exa > /dev/null; then
					! type cargo > /dev/null && rust::install
					cargo install exa
				fi
			fi
		}

		function utilities::pe()
		{
			#path-extractor
			if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
				[[ -x $HOME/.config/go/bin/path-extractor ]] && sudo rm $HOME/.config/go/bin/path-extractor
			else
				if ! type path-extractor > /dev/null; then
					if ! type go > /dev/null; then
						go::install
						go::path
					fi
					sudo go get https://github.com/edi9999/path-extractor
				fi
			fi
		}

		function utilities::common()
		{
			! type ag        > /dev/null && sudo apt-get -y install silversearcher-ag
			! type ack       > /dev/null && sudo apt-get -y install ack-grep
			! type pandoc    > /dev/null && sudo apt-get -y install pandoc
			! type readline  > /dev/null && sudo apt-get -y install readline
			! type fuck      > /dev/null && sudo pip3 install thefuck
			! type tree      > /dev/null && sudo apt-get install tree
			! type dos2unix  > /dev/null && sudo apt-get install dos2unix
			! type htop      > /dev/null && sudo apt-get install htop
			! type highlight > /dev/null && sudo apt-get install highlight
			! type ctags     > /dev/null && sudo apt-get install ctags
			#! type cheat     > /dev/null && sudo pip3 install cheat
		}
	#TUIs
		#ZSH
			function zsh::dotfile()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/.zshrc ]] && sudo rm $HOME/.zshrc
				else
					if  [[ ! -f  $HOME/.zshrc ]]; then
						curl "$DOTFILES"/.zshrc > $HOME/.zshrc
					fi
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
				type zsh > /dev/null && sudo apt-get -y remove zsh
			}

			function zsh::add()
			{
				zsh::install
				zsh::ohmyzsh
				zsh::dotfile
			}

			function zsh::remove()
			{
				zsh::uninstall
				zsh::dotfile delete
			}
		#TMUX
			function tmux::dotfile()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/.tmux.conf ]] && sudo rm $HOME/.tmux.conf
				else
					if [[ ! -f  $HOME/.tmux.conf ]]; then
						curl "$DOTFILES"/.tmux.conf > $HOME/.tmux.conf
					fi
				fi
			}

			function tmux::aliases()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/aliases/.tmux ]] && sudo rm $HOME/aliases/.tmux
				else
					[[ ! -d $HOME/aliases ]]       && mkdir $HOME/aliases
					[[ ! -f $HOME/aliases/.tmux ]] && curl "$DOTFILES"/aliases/.tmux > $HOME/aliases/.tmux
				fi
			}

			function tmux::pacman()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -d $HOME/.tmux/plugins/tpm ]] && sudo rm -rf $HOME/.tmux/plugins/tpm
				else
					if [[ $(tmux -V | cut -d' ' -f2) > 1.9 ]] && ! -d $HOME/.tmux/plugins/tpm; then
						git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
						[[ -f $HOME/.tmux.conf ]] && tmux source $HOME/.tmux.conf
					fi
				fi
			}

			function tmux::install()
			{
				! type tmux > /dev/null && sudo apt-get -y install tmux
			}
			function tmux::uninstall()
			{
				type tmux > /dev/null && sudo apt-get -y remove tmux
			}

			function tmux::add()
			{
				tmux::install
				tmux::pacman
				tmux::dotfile
				tmux::aliases
			}

			function tmux::remove()
			{
				tmux::uninstall
				tmux::dotfile delete
				tmux::aliases delete
				tmux::pacman delete
			}
		#NVIM
			function nvim::dotfile()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/.config/nvim/init.vim ]] && sudo rm $HOME/.config/nvim/init.vim
				else
					if [[ ! -f  $HOME/.config/nvim/init.vim ]]; then
						if [[ ! -d $HOME/.config/nvim ]]; then
							mkdir -p $HOME/.config/nvim
						fi
						curl "$DOTFILES"/init.vim > $HOME/.config/nvim/init.vim
					fi
				fi
			}

			function nvim::pacman()
			{
				#vim-plug
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/.local/share/nvim/site/autoload/plug.vim ]] && sudo rm $HOME/.local/share/nvim/site/autoload/plug.vim
				else
					if [[ ! -f  $HOME/.local/share/nvim/site/autoload/plug.vim ]]; then
						curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
							https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
					fi
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
				[[ -d $HOME/.local/share/nvim ]] && sudo rm -rf $HOME/.local/share/nvim
			}
			function nvim::add()
			{
				nvim::install
				nvim::pacman
				nvim::dotfile
			}

			function nvim::remove()
			{
				nvim::uninstall
				nvim::dotfile delete
				nvim::pacman delete
			}
		#VIM
		#FZF
			function fzf::aliases()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/aliases/.fzf ]] && sudo rm $HOME/aliases/.fzf
				else
					[[ ! -d $HOME/aliases ]] && mkdir $HOME/aliases
					curl "$DOTFILES"/aliases/.fzf > $HOME/aliases/.fzf
				fi
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
			}

			function fzf::add()
			{
				fzf::install
				fzf::aliases
			}

			function fzf::remove()
			{
				fzf::uninstall
				fzf::aliases delete
			}
		#VIFM
			function vifm::dotfile()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/.vifm/vifmrc ]] && sudo rm $HOME/.vifm/vifmrc
				else
					[[ ! -f $HOME/.vifm/vifmrc ]] && curl "$DOTFILES"/vifmrc > $HOME/.vifm/vifmrc
				fi
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
			}

			function vifm::add()
			{
				vifm::install
				vifm::dotfile
			}

			function vifm::remove()
			{
				vifm::uninstall
				vifm::dotfile delete
				[[ -d $HOME/.vifm ]] && sudo rm -rf $HOME/.vifm
			}
		#FASD
			function fasd::aliases()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/aliases/.fasd ]] && sudo rm $HOME/aliases/.fasd
				else
					[[ ! -d $HOME/aliases ]] && mkdir $HOME/aliases
					[[ ! -f $HOME/aliases/.fasd ]]   && curl "$DOTFILES"/aliases/.fasd > $HOME/aliases/.fasd
				fi
			}

			function fasd::install()
			{
				[[ ! -d $HOME/fasd ]] && git clone https://github.com/clvv/fasd $HOME/fasd
				cd $HOME/fasd && make install
			}

			function fasd::uninstall()
			{
				[[ -d $HOME/fasd ]] && sudo rm -rf $HOME/fasd
			}
			function fasd::add()
			{
				fasd::install
				fasd::aliases
			}

			function fasd::remove()
			{
				fasd::uninstall
				fasd::aliases delete
			}
		#EMACS
			function emacs::dotfile()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/.emacs ]] && sudo rm $HOME/.emacs
				else
					if [[ ! -f  $HOME/.emacs ]]; then
						curl "$DOTFILES"/init.el > $HOME/.emacs
					fi
				fi
			}

			function emacs::install()
			{
				sudo apt-add-repository -y ppa:adrozdoff/emacs
				sudo apt update
				sudo apt install -y emacs25
			}

			function emacs::uninstall()
			{
				sudo apt-get remove -y emacs25
			}

			function emacs::plugins()
			{
				EPPATH="$HOME/.emacs.d/packages"
				ETPATH="$HOME/.emacs.d/themes"
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -d $EPPATH ]] && sudo rm -rf $EPPATH
					[[ -d $ETPATH ]] && sudo rm -rf $ETPATH
				else
					#EVIL
						git clone https://github.com/emacs-evil/evil/                      $EPPATH/evil
						git clone https://github.com/cofi/evil-leader/                     $EPPATH/evil-leader
						git clone https://github.com/syl20bnr/evil-escape/                 $EPPATH/evil-escape
						git clone https://github.com/emacs-evil/evil-surround/             $EPPATH/evil-surround
						git clone https://github.com/redguardtoo/evil-nerd-commenter/      $EPPATH/evil-nerd-commenter
						git clone https://github.com/TheBB/evil-indent-plus/               $EPPATH/evil-indent-plus
						git clone https://github.com/gabesoft/evil-mc/                     $EPPATH/evil-mc
						git clone https://github.com/cofi/evil-numbers/                    $EPPATH/evil-numbers
						git clone https://github.com/noctuid/evil-textobj-column/          $EPPATH/evil-textobj-column
						git clone https://github.com/supermomonga/evil-textobj-entire/     $EPPATH/evil-textobj-entire
						git clone https://github.com/syohex/evil-textobj-line/             $EPPATH/evil-textobj-line
						git clone https://github.com/noctuid/evil-textobj-anyblock/        $EPPATH/evil-textobj-anyblock
						git clone https://github.com/redguardtoo/evil-matchit/             $EPPATH/evil-matchit
						git clone https://github.com/edkolev/evil-lion/                    $EPPATH/evil-lion
						git clone https://github.com/wcsmith/evil-args/                    $EPPATH/evil-args
						git clone https://github.com/7696122/evil-terminal-cursor-changer/ $EPPATH/evil-terminal-cursor-changer
						git clone https://github.com/alexmurray/evil-vimish-fold/          $EPPATH/evil-vimish-fold
						git clone https://github.com/Somelauw/evil-org-mode/               $EPPATH/evil-org-mode
						git clone https://github.com/krisajenkins/evil-tabs/               $EPPATH/evil-tabs
						git clone https://github.com/edkolev/evil-goggles/                 $EPPATH/evil-goggles
						git clone https://github.com/tarao/evil-plugins/                   $EPPATH/evil-plugins
						git clone https://github.com/Dewdrops/evil-exchange                $EPPATH/evil-exchange
						git clone https://github.com/Dewdrops/evil-extra-operator          $EPPATH/evil-extra-operator
						git clone https://github.com/bling/evil-jumper                     $EPPATH/evil-jumper
						git clone https://github.com/bling/evil-visualstar                 $EPPATH/evil-visualstar
						git clone https://github.com/hlissner/evil-snipe                   $EPPATH/evil-snipe
						git clone https://github.com/coldnew/linum-relative                $EPPATH/linum-relative
						git clone https://github.com/syl20bnr/vi-tilde-fringe              $EPPATH/vi-tilde-fringe
					#EMACS
						git clone https://github.com/mrkkrp/vimish-fold/      $EPPATH/vimish-fold
						git clone https://github.com/winterTTr/ace-jump-mode/ $EPPATH/ace-jump-mode
						git clone https://github.com/noctuid/targets.el/      $EPPATH/targets.el
						git clone https://github.com/gregsexton/origami.el    $EPPATH/origami.el
					#PRODUCTIVITY
						git clone https://github.com/emacs-helm/helm         $EPPATH/helm
						git clone https://github.com/justbur/emacs-which-key $EPPATH/emacs-which-key
					#META
					#DEVELOPMENT
						git clone https://github.com/syohex/emacs-quickrun $EPPATH/emacs-quickrun
					#LANGUAGES
						git clone https://github.com/jwiegley/org-mode/ $EPPATH/org-mode
						git clone https://github.com/nverno/vimscript   $EPPATH/vimscript
					#LOOK & FEEL
						git clone https://github.com/rakanalh/emacs-dashboard          $EPPATH/dashboard
						git clone https://github.com/milkypostman/powerline/           $EPPATH/powerline
						git clone https://github.com/Dewdrops/powerline		           $EPPATH/evil-powerline
						git clone https://github.com/AnthonyDiGirolamo/airline-themes/ $EPPATH/airline-themes
						git clone https://github.com/jonathanchu/emacs-powerline/      $EPPATH/emacs-powerline
						git clone https://github.com/TheBB/spaceline                   $EPPATH/spaceline
						#THEMES
							curl https://raw.githubusercontent.com/hbin/molokai-theme/master/molokai-theme.el > $ETPATH/molokai-theme.el
							curl https://raw.githubusercontent.com/dracula/emacs/master/dracula-theme.el      > $ETPATH/dracula-theme.el
					#DEPENDENCIES
						git clone https://github.com/purcell/page-break-lines $EPPATH/page-break-lines
						git clone https://github.com/emacs-evil/goto-chg      $EPPATH/goto-chg
						git clone https://github.com/emacsmirror/undo-tree    $EPPATH/undo-tree
						git clone https://github.com/jwiegley/emacs-async     $EPPATH/emacs-async
						git clone https://github.com/auto-complete/popup-el   $EPPATH/popup-el
					#LIBRARIES
						git clone https://github.com/magnars/dash.el $EPPATH/dash.el
						git clone https://github.com/rejeep/f.el     $EPPATH/f.el
						git clone https://github.com/magnars/s.el    $EPPATH/s.el
				}
				fi
			function emacs::add()
			{
				emacs::install
				emacs::plugins
				emacs::dotfile
			}

			function emacs::remove()
			{
				emacs::uninstall
				emacs::plugins delete
				emacs::dotfile delete
			}
		#SPACEMACS
			function spacemacs::dotfile()
			{
				if [[ $1 =~ delete || $1 =~ remove || $1 =~ uninstall ]]; then
					[[ -f $HOME/.spacemacs ]] && sudo rm $HOME/.spacemacs
				else
					if [[ ! -f  $HOME/.spacemacs ]]; then
						curl "$DOTFILES"/.spacemacs > $HOME/.spacemacs
					fi
				fi
			}

			function spacemacs::install()
			{
				git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
			}

			function spacemacs::uninstall()
			{
				sudo rm -rf ~/.emacs.d/**
			}

			#function spacemacs::plugins(){}
			function spacemacs::add()
			{
				spacemacs::install
				spacemacs::dotfile
			}

			function spacemacs::remove()
			{
				spacemacs::uninstall
				spacemacs::dotfile delete
			}
	#GUIs
	#DEVELOPMENT
		#DATABASES
			#SQLITE
				function sqlite::install()
				{
					! type sqlite3 > /dev/null && sudo apt-get -y install sqlite3 libsqlite3-dev
				}

				function sqlite::uninstall()
				{
					type sqlite3 > /dev/null && sudo apt-get remove -y sqlite3 libsqlite3-dev
				}
			#MYSQL
				function mysql::install()
				{
					! type mysql           > /dev/null && sudo apt-get install -y mysql-server
					! type mysql-workbench > /dev/null && sudo apt-get install -y mysql-workbench
				}

				function mysql::uninstall()
				{
					type mysql           > /dev/null && sudo apt-get remove -y mysql-server
					type mysql-workbench > /dev/null && sudo apt-get remove -y mysql-workbench
				}
			#MONGODB
				function mongodb::install()
				{
					if ! type mongo > /dev/null; then
						sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
						echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
						sudo apt-get update
						sudo apt-get install -y mongodb-org --allow-unauthenticated

						{
							echo "[Unit]"
							echo "Description=MongoDB Database"
							echo "After=network.target"
							echo "Documentation=https://docs.mongodb.org/manual"
							echo "[Service]"
							echo "User=mongodb"
							echo "Group=mongodb"
							echo "ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf"
							echo "[Install]"
							echo "WantedBy=multi-user.target"
						} >> /etc/systemd/system/mongodb.service

						systemctl daemon-reload
						sudo systemctl start mongodb
					fi
				}

				function mongodb::uninstall()
				{
					type mongo > /dev/null && sudo apt-get purge -y mongodb-org*
					sudo rm -r /var/log/mongodb
					sudo rm -r /var/lib/mongodb
				}
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
	#PERSONAL
		#function install::install(){}
		#function uninstall::uinstall(){}
	#MINIMAL
		function install::minimal()
		{
			zsh::add
			tmux::add
			nvim::add
			fzf::add
			vifm::add
			fasd::add
		}

		function uninstall::minimal()
		{
			zsh::remove
			tmux::remove
			nvim::remove
			fzf::remove
			vifm::remove
			fasd::remove
		}
	#DOTFILES
		function install::dotfile()
		{
			zsh::dotfile
			tmux::dotfile
			nvim::dotfile
			vifm::dotfile

			tmux::aliases
			fasd::aliases
			fzf::aliases
		}

		function uninstall::dotfile()
		{
			zsh::dotfile delete
			tmux::dotfile delete
			nvim::dotfile delete
			vifm::dotfile delete
			emacs::dotfile delete
			spacemacs::dotfile delete

			tmux::aliases delete
			fasd::aliases delete
			fzf::aliases delete
		}
	#UTILITIES
		function install:utilities()
		{
			utilities::common
			utilities::exa
			utilities::pq
		}

		function uninstall:utilities()
		{
			utilities::common uninstall
			utilities::exa uninstall
			utilities::pq uninstall
		}


#MAIN FUNCTION
	function main()
	{
		#code goes here
		log::log "main() is empty"
	}
main
