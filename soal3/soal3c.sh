#!/bin/bash

# Masuk ke folder repo dulu
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"

# Menentukan nama file
get_file_name_result=""
get_file_name() {
    if [ $1 -lt 10 ]
    then
        get_file_name_result="Koleksi_0$1"
    else
        get_file_name_result="Koleksi_$1"
    fi
}

# Tentukan link download berdasarkan apa yang ada kemarin 
kemarin=$(date -d yesterday +"%d-%m-%Y")
current_date=$(date +"%d-%m-%Y")

# Cek apakah kemarin ada kucing?
if [ -d "Kucing_$kemarin" ]
then
    echo "Kemarin ada kucing, sekarang download kelinci."
    link_download="bunny"
    nama_folder="Kelinci_$current_date"
else
    echo "Kemarin tidak ada kucing, sekarang download kucing."
    link_download="kitten"
    nama_folder="Kucing_$current_date"
fi

# Iterasi sampai 23
file_ke=1
while [ "$file_ke" -le 23 ]
do

    # Tentukan filename dulu
    get_file_name "$file_ke"
    filename=$get_file_name_result
    wget -O "$filename" -a Foto.log "https://loremflickr.com/320/240/$link_download"

    # Cari, ada yang sama atau tidak
    is_same=0
    for((i=1; i < $file_ke; i++))
    do
        get_file_name "$i"
        cmp_filename=$get_file_name_result
        cmp_result=$(cmp "./$cmp_filename" "./$filename")
        cmp_exit=$?
        if [ $cmp_exit -eq 0 ]
        then
            is_same=1
            break
        fi
    done

    # Lakukan sesuai soal :v
    if [ $is_same -eq 1 ]
    then
        echo "$filename: Hasil download sama, hapus dan ulang."
        rm "./$filename"
    else
        echo "$filename: Hasil download berbeda, lanjut."
        file_ke=$(($file_ke + 1)) 
    fi
done

# Done
echo "Sudah terdownload semua"

# Bikin folder, lalu dipindah ke folder itu
mkdir "$nama_folder"
mv ./Koleksi_* "./$nama_folder/"
mv ./Foto.log "./$nama_folder/"

# Sudah
echo "Moved to $nama_folder"