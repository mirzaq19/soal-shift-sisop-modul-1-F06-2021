#!/bin/bash

# Ambil tanggal hari ini
hariini=$(date +"%d%m%Y")

# Zip file-filenya
zip -re Koleksi.zip Kucing_* Kelinci_* -P "$hariini"

# Hapus yang di luar
rm -r Kucing_* Kelinci_*