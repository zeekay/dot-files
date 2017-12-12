#!/bin/sh

if  [ $# -lt 3 ]; then
    echo "Usage:"
    echo "./makedebpackage.sh azcopyfolder debianfolder packagename"
    exit 1
fi

AZCOPYFOLDER=$1
DEBIANFOLDER=$2
PACKAGENAME=$3

if [ ! -d $AZCOPYFOLDER ]; then 
    echo $AZCOPYFOLDER does not exist
    exit 1
fi

echo starting making package from $AZCOPYFOLDER

if [ ! -d $DEBIANFOLDER ]; then
    mkdir $DEBIANFOLDER
    if [ ! $? -eq 0 ]; then 
        exit 1
    fi
fi

mkdir -p $DEBIANFOLDER/DEBIAN
cp -f $AZCOPYFOLDER/installation/DEBIAN/control $DEBIANFOLDER/DEBIAN

AUTOCOMPLETEFOLDER=$DEBIANFOLDER/etc/bash_completion.d

mkdir -p $AUTOCOMPLETEFOLDER
if [ ! $? -eq 0 ]; then
    exit 1
fi

cp -f $AZCOPYFOLDER/azcopy_autocomplete $DEBIANFOLDER/etc/bash_completion.d/azcopy

BINFOLDER=$DEBIANFOLDER/usr/bin

mkdir -p $BINFOLDER
if [ ! $? -eq 0 ]; then
    exit 1
fi

cp -f $AZCOPYFOLDER/startup $DEBIANFOLDER/usr/bin/azcopy
chmod a+x $DEBIANFOLDER/usr/bin/azcopy

LIBFOLDER=$DEBIANFOLDER/usr/lib/azcopy

mkdir -p $LIBFOLDER
if [ ! $? -eq 0 ]; then
    exit 1
fi

cp -f $AZCOPYFOLDER/azcopy $LIBFOLDER
cp -f $AZCOPYFOLDER/LICENSE $LIBFOLDER
cp -f $AZCOPYFOLDER/ThirdPartyNotices $LIBFOLDER
chmod a+x $LIBFOLDER/azcopy

mkdir -p $LIBFOLDER/bin
if [ ! $? -eq 0 ]; then
    exit 1
fi


rsync -av --exclude startup --exclude installation --exclude LICENSE --exclude ThirdPartyNotices --exclude azcopy $AZCOPYFOLDER/* $LIBFOLDER/bin 

dpkg-deb --build $DEBIANFOLDER $PACKAGENAME
