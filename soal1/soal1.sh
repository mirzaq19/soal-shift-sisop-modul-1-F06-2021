#!/bin/bash

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
grep -oP '(?<=ERROR ).+(?= \()' syslog.log | sort | uniq -c
JE=$(grep -c 'ERROR' syslog.log)
echo "Jumlah ERROR: ${JE}"

#soal 1C
printf "Username,INFO,ERROR\n" 
username=($(grep -oP '\(\w+.?\w+\)' syslog.log | sort | uniq))

E=$(grep -oP 'ERROR.+' syslog.log)
Er=$(grep -oP '\(\w+.?\w+\)' <<< "$E" | sort)
I=$(grep -oP 'INFO.+' syslog.log)
In=$(grep -oP '\(\w+.?\w+\)' <<< "$I" | sort)

for i in "${!username[@]}"
do
usertemp="${username[$i]}"
Inn=$(grep -c $usertemp <<< "$In")
Ern=$(grep -c $usertemp <<< "$Er")
userfinal=$(grep -oP '(?<=\()\w+.?\w+' <<< "$usertemp")
printf "%s,%d,%d\n" "$userfinal" "$Inn" "$Ern"
done

#soal 1D
printf "Error,Count\n" > "error_message.csv"
temp=($(grep -oP '(?<=ERROR ).+(?= \()' syslog.log | sort | uniq -c | sort -nr))

re='^[0-9]+$'
it=-1
one=1
for i in "${!temp[@]}"
do
if ! [[ "${temp[$i]}" =~ $re ]]
then
words[$it]+="${temp[$i]}"
if ! [[ "${temp[$i+$one]}" =~ $re ]]
then
words[$it]+=" "
fi
else
it=$it+$one
numbers[$it]="${temp[$i]}"
fi
done

for i in "${!words[@]}"
do
sentence="${words[$i]}"
number="${numbers[$i]}"
printf "%s,%d\n" "$sentence" "$number" >> "error_message.csv"
done

#soal 1E
#Pertama ambil semua user
printf "Username,INFO,ERROR\n" > "user_statistic.csv"
username=($(grep -oP '\(\w+.?\w+\)' syslog.log | sort | uniq))

E=$(grep -oP 'ERROR.+' syslog.log)
Er=$(grep -oP '\(\w+.?\w+\)' <<< "$E" | sort)
I=$(grep -oP 'INFO.+' syslog.log)
In=$(grep -oP '\(\w+.?\w+\)' <<< "$I" | sort)

for i in "${!username[@]}"
do
usertemp="${username[$i]}"
Inn=$(grep -c $usertemp <<< "$In")
Ern=$(grep -c $usertemp <<< "$Er")
userfinal=$(grep -oP '(?<=\()\w+.?\w+' <<< "$usertemp")
printf "%s,%d,%d\n" "$userfinal" "$Inn" "$Ern">> "user_statistic.csv"
done
