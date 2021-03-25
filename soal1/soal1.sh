#!/bin/bash
# while loops
 
#soal 1A
#Error/Info
regex1="(ERROR|INFO)"
#Log message
regex2="(?<=ERROR |INFO ).+(?= \()"
#User
regex3="(?<=\()\w+\.?\w+"
#Combined
regex4="(ERROR|INFO).+(?= \() |(?<=\()\w+\.?\w+)"

#soal 1B
#semua msg Error (Error tidak masuk) sampai bertemu ' ('
grep -oP '(?<=ERROR ).+(?= \()' syslog.log
#Menghitung Error msg dan dimasukkin var
E=$(grep -c 'ERROR' syslog.log)
echo "Jumlah ERROR: ${E}"

#soal 1C
#semua msg Error sampai akhir line
E=$(grep -oP 'ERROR.+' syslog.log)
echo "ERROR User"
#Semua error user dengan jumlah error msg dari user
grep -oP '(?<=()w+.?w+' <<< "$E" | sort | uniq -c
#semua msg msg sampai akhir line
I=$(grep -oP 'INFO.+' syslog.log)
echo "INFO User"
#Semua info user dengan jumlah info msg dari user
grep -oP '(?<=()w+.?w+' <<< "$I" | sort | uniq -c
 
#soal 1D
#masukan header
printf "Error,Count\n" > "error_message.csv"
#ambil error dan user dalam array
temp=($(grep -oP '(?<=ERROR ).+(?= ()' syslog.log | sort | uniq -c | sort -nr))
#angka
re='^[0-9]+$'
it=-1
one=1

for i in "${!temp[@]}"
do
#jika array bukan angka maka
    if ! [[ "${temp[$i]}" =~ $re ]]
        then
        #tambah substring pada array ke $it
        words[$it]+="${temp[$i]}"
        #jika array+1 bukan angka maka
            if ! [[ "${temp[$i+$one]}" =~ $re ]]
                then
                #tambah substring pada array ke $it
                words[$it]+=" "
            fi
    else
    #jika ketemu angka
    it=$it+$one
    numbers[$it]="${temp[$i]}"
    fi
done
#memasukan data pada csv
for i in "${!words[@]}"
    do
    sentence="${words[$i]}"
    number="${numbers[$i]}"
    printf "%s,%d\n" "$sentence" "$number" >> "error_message.csv"
done
 
#soal 1E

printf "Username,INFO,ERROR/n" > "user_statistic.csv"
#Pertama ambil semua user
username=($(grep -oP '(?<=()w+.?w+' syslog.log | sort | uniq))
#Mengambil semua Error
E=$(grep -oP 'ERROR.+' syslog.log)
#Mengambil semua INFO
I=$(grep -oP 'INFO.+' syslog.log)

#Melakukan looping agar dengan menghitung username di dalam 
#Error dan Info dan memasuki dalam csv
for i in "${!username[@]}"
do
    usertemp="${username[$i]}"
    In=$(grep -c $usertemp <<< "$I")
    Er=$(grep -c $usertemp <<< "$E")
    printf "%s,%d,%d\n" "$usertemp" "$In" "$Er" >> "user_statistic.csv"
done
