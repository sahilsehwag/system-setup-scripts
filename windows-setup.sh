#! /bin/bash

#HELP
	if [[ "*" ~= help ]]; then
		echo choco = INSTALL CHOCOLATEY
		echo setup = SETUP MACHINE
		echo gui   = INSTALL GUI APPLICATIONS
	fi
#SETUP
#CHOCOLATEY
	if [[ "*" ~= choco ]]; then
		@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
	fi
#GUI
	if [[ "*" ~= gui ]]; then
		#COMMON
			choco install -y googlechrome
			choco install -y 7zip
			choco install -y ccleaner
			choco install -y utorrent
			choco install -y idm
		#MEDIA
			choco install -y spotify
			choco install -y vlc
		#PRODUCTIVITY
			choco install -y pushbullet
			choco install -y ditto
		#DEVELOPMENT
			#choco install -y vim
		#MISCELLANOUS
	fi
#BASH
