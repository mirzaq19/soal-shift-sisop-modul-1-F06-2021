#!/bin/bash

# Ambil tanggal hari ini
hariini=$(date +"%d%m%Y")

# Unzip file-filenya
unzip -P "$hariini" Koleksi.zip

# Hapus file zip
rm *.zip