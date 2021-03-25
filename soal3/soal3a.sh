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

# Iterasi sampai 23
file_ke=1
while [ "$file_ke" -le 23 ]
do
    # Tentukan filename dulu
    get_file_name "$file_ke"
    filename=$get_file_name_result
    wget -O "$filename" -a Foto.log https://loremflickr.com/320/240/kitten

    # Cari, ada yang sama atau tidak
    is_same=0
    awk_link_array=($(awk '/https:\/\/loremflickr.com\/cache\/resized\// {print $3}' ./Foto.log))
    awk_array_length=(${#awk_link_array[@]})
    for((i=0; i < ($awk_array_length - 1); i++))
    do
        if [ "${awk_link_array[i]}" == "${awk_link_array[$(($awk_array_length - 1))]}" ]
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