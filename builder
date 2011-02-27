#!/bin/sh

source /home/$(whoami)/.syncaurrc

cd $PKGDIR
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
	    echo "Building $PKGFILE";
	    makepkg -f;
	else
	    echo "Package $PKGFILE have already built."
	fi
	
	cd ..;
    fi
done

echo "Building done."
