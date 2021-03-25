#!/bin/bash

# Masuk ke folder repo dulu
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"

# Ambil tanggal hari ini
hariini=$(date +"%d%m%Y")

# Unzip file-filenya
unzip -P "$hariini" Koleksi.zip

# Hapus file zip
rm ./Koleksi.zip