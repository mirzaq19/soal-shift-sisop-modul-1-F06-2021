#!/bin/bash

# Masuk ke folder repo dulu
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"

# Eksekusi yang 3a (Demi efisiensi, karena memang itu yang dieksekusi)
bash ./soal3a.sh

# Bikin folder, lalu dipindah ke folder itu
current_date=$(date +"%d-%m-%Y")
mkdir "$current_date"
mv ./Koleksi_* "./$current_date/"
mv ./Foto.log "./$current_date/"

# Sudah
echo "Moved to $current_date"