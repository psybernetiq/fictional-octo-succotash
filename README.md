Updated version of the dnscrypt-proxy, since the other one seems to have been abandoned in the magisk repo.
This version is based on that one, with some enhancements to automate the placement of files, create blocklists.
Some of this is taken from the Invizible app for Android by gedsh, eventually can be used with tor and i2pd


#######################  BUILDING DNSCRYPT-PROXY BINARY  ############################################
### 1) build tools
###...on Linux Mint:
	sudo apt install git golang
###...on Android (termux)
	pkg install git golang
### 2)create working directory
	mkdir dnscrypt-proxy-src
	cd dnscrypt-proxy-src
### 3) Clone the repo
	git clone https://github.com/jedisct1/dnscrypt-proxy src
### 4) set environment variables
	# If building on Linux Mint, for aarch64 android
	#set paths for the extracted NDK and standalone toolchain install
	NDK_TOOLS=android-ndk-r15c
	INSTALL_DIR=ndk-standalone-r15c
	MAKE_TOOLCHAIN=$NDK_TOOLS/build/tools/make_standalone_toolchain.python
	NDK_STANDALONE=
	PATH=$PATH:$NDK_STANDALONE/arm64/bin
	PATH=$PATH:$NDK_STANDALONE/arm/bin
	PATH=$PATH:$NDK_STANDALONE/x86_64/bin
	PATH=$PATH:$NDK_STANDALONE/x86/bin
	export CC=aarch64-linux-android-clang
	export CCX=aarch64-linux-android-clang++
	export CGO_ENABLED=1
	export GOOS=linux
	export GOARCH=amd64
	# If building on Android (termux)
	export GOOS=android
	export GOARCH=arm64 (or: export GOARCH=arm; export GOARM=7)
### 5) build the binary
	cd src/dnscrypt-proxy
	go build -ldflags="-s -w" -mod vendor

##############333333333333333333333333333333333333333333333333333333333333333333333333333333333333#

Put the binary in the folder called 'binary'
Optional: run the python query to update the blocked-names.txt
Use the config files to, well, configure the creation of the lists.
	python /data/media/0/dnscrypt-proxy/lists/generate-domains-blocklist.py >> /data/media/0/dnscrypt-proxy/lists/blocked-names.txt
zip up the files/folders and flash in magisk

############# Other helpful commands to debug/start/stop. Some only useful on Linux Mint.
dnscrypt-proxy -config /data/media/0/dnscrypt-proxy/dnscrypt-proxy.toml
dnscrypt-proxy -check /data/media/0/dnscrypt-proxy/dnscrypt-proxy.toml
pkill - HUP dnscrypt-proxy
dnscrypt-proxy -service install
dnscrypt-proxy -service start
dnscrypt-proxy -service stop
dnscrypt-proxy -service restart

################ TROUBLESHOOTING ######################################################
on android, this folder is in /data/media/0/ which is different, permission-wise, than /sdcard/ or /storage/emulated/0. Keep in mind if you can't delete the folder if you are trying to uninstall
might need to fix permissions on android
