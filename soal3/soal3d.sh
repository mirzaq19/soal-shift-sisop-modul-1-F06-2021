#!/bin/bash

# Masuk ke folder repo dulu
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"

# Ambil tanggal hari ini
hariini=$(date +"%m%d%Y")

# Zip file-filenya
zip -rem Koleksi.zip Kucing_* Kelinci_* -P "$hariini"