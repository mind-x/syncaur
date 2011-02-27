#!/bin/sh

source /home/$(whoami)/.syncaurrc

ARCH=$(uname -m)

if [[ $1 == "trunk" ]]; then
	cd $TRUNKDIR;
else
	cd $PKGDIR;
fi

for DIR in $(ls);
    do if [[ -d $DIR ]]; then
	cd $DIR;
	PKGVER=$(cat PKGBUILD | grep -m 1 pkgver= | sed 's/pkgver=//');
	PKGREL=$(cat PKGBUILD | grep -m 1 pkgrel= | sed 's/pkgrel=//');
	PKGARCH=$(cat PKGBUILD | grep -m 1 arch=\(\' | sed "s/arch=('//" | cut -c -3);
	if [[ $PKGARCH == "any" ]]; then
	    ARCH=$PKGARCH;
	else
	    ARCH=$(uname -m);
	fi
	PKGFILE="$DIR-$PKGVER-$PKGREL-$ARCH.pkg.tar.xz"
	if ! [[ -f $PKGFILE ]]; then
	    rm *.pkg.tar.xz;
	    echo -e "\e[44;31m==> \e[1;37mBuilding $PKGFILE\e[0m";
	    makepkg -f;
	    echo -e "\e[44;31m==> \e[1;37mUploading $PKGFILE to $FTP.\e[0m";
	    wput $PKGFILE ftp://$USER:$PASS@$FTP/$ARCH/;
	else
	    echo -e "\e[44;31m==> \e[1;37mPackage $PKGFILE have already built.\e[0m"
	fi
	
	cd ..;
    fi
done

echo -e "\e[44;31m==> \e[1;37mBuilding done.\e[0m"
