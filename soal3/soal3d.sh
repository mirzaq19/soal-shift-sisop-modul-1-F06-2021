#!/bin/bash

# Ambil tanggal hari ini
hariini=$(date +"%d%m%Y")

# Zip file-filenya
zip -rem Koleksi.zip Kucing_* Kelinci_* -P "$hariini"