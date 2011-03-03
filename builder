#!/bin/sh

source /home/$(whoami)/.syncaurrc

ARCH=$(uname -m)

if [[ $1 == "--help" || $1 == "-h" ]]; then
	echo "использование: fetch <параметр>
параметры:
-h  --help       Помощь по использованию скрипта.
<без параметров> Собирает и отправляет пакеты по FTP из основного дерева сборки.
-t --trunk       Собирает и отправляет по FTP пакеты из svn и git.";
	exit;
fi
if [[ $1 == "--trunk" || $1 == "-t" ]]; then
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
	if [[ $PKGARCH != "any" ]]; then
	    PKGARCH=$(uname -m);
	fi
	PKGFILE="$DIR-$PKGVER-$PKGREL-$PKGARCH.pkg.tar.xz"
	if ! [[ -f $PKGFILE ]]; then
	    rm *.pkg.tar.xz;
	    echo -e "\e[44;31m==> \e[1;37mСборка $PKGFILE\e[0m";
	    makepkg -fs;
	    echo -e "\e[1;31m==> \e[1;37mОтправка $PKGFILE в $FTP.\e[0m";
	    lftp $FTP/$ARCH -u $USER,$PASS -e "mput *.pkg.tar.xz; exit";
	else
	    echo -e "\e[42;31m==> \e[1;37mПакет $PKGFILE уже собран.\e[0m"
	fi
	
	cd ..;
    fi
done

echo -e "\e[44;31m==> \e[1;37mСборка завершена.\e[0m"
