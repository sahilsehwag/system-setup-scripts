#! /bin/bash
#CHOCOLATEY PACKAGE MANAGER

if [[ ! $@ ]]; then
	choco install -y googlechrome
	choco install -y 7zip
	choco install -y ccleaner
	choco install -y utorrent
	choco install -y idm
	choco install -y pushbullet
	choco install -y ditto

	choco install -y spotify
	choco install -y vlc

	choco install -y vim
fi
