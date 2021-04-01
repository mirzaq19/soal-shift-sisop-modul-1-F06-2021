# soal-shift-sisop-modul-1-F06-2021

## Soal Shift Modul 1

### **Soal No. 1**

Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, *ticky*. Terdapat 2 laporan yang harus dia buat, yaitu laporan **daftar peringkat pesan error** terbanyak yang dibuat oleh *ticky* dan laporan **penggunaan user** pada aplikasi *ticky*. Untuk membuat laporan tersebut, Ryujin harus melakukan beberapa hal berikut:

**(a)** Mengumpulkan informasi dari log aplikasi yang terdapat pada file `syslog.log`. Informasi yang diperlukan antara lain: jenis log (`ERROR/INFO`), pesan log, dan username pada setiap baris lognya. Karena Ryujin merasa kesulitan jika harus memeriksa satu per satu baris secara manual, dia menggunakan regex untuk mempermudah pekerjaannya. Bantulah Ryujin membuat regex tersebut.

**(b)** Kemudian, Ryujin harus menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.

**(c)** Ryujin juga harus dapat menampilkan jumlah kemunculan log `ERROR` dan `INFO` untuk setiap *user*-nya.

Setelah semua informasi yang diperlukan telah disiapkan, kini saatnya Ryujin menuliskan semua informasi tersebut ke dalam laporan dengan format file `csv`.

**(d)** Semua informasi yang didapatkan pada poin **b** dituliskan ke dalam file `error_message.csv` dengan header `Error,Count` yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya **diurutkan** berdasarkan jumlah kemunculan pesan error dari yang terbanyak.

Contoh :

```text
Error,Count
Permission denied,5
File not found,3
Failed to connect to DB,2
```

(e) Semua informasi yang didapatkan pada poin **c** dituliskan ke dalam file `user_statistic.csv` dengan header **`Username,INFO,ERROR`** **diurutkan** berdasarkan username secara **ascending**.

Contoh :

```text
Username,INFO,ERROR
kaori02,6,0
kousei01,2,2
ryujin.1203,1,3
```

**Catatan** :

- Setiap baris pada file syslog.log mengikuti pola berikut :

```text
 <time> <hostname> <app_name>: <log_type> <log_message> (<username>)
```

- **Tidak boleh** menggunakan AWK

### **Jawaban No. 1A**

```bash
#!/bin/bash
# while loops
 
#soal 1A
#Error/Info
regex1="(ERROR|INFO)"
#Log message
regex2="(?<=ERROR |?<=INFO ).+(?= \()"
#User
regex3="(?<=\()\w+\.?\w+"
#Combined
regex4="(ERROR|INFO).+(?= \() |(?<=\()\w+\.?\w+)"
```
### **Penjelasan No. 1A**

Pada No.1a diminta untuk membuat regex yang dapat menampilkan jenis log (`ERROR/INFO`), pesan log, dan username pada setiap baris lognya.

```
#Error/Info
regex1="(ERROR|INFO)"
```
Regex `(ERROR|INFO)` mencari setiap baris yang memiliki kata (`ERROR/INFO`)
```
#Log message
regex2="(?<=ERROR |INFO ).+(?= \()"
```
Regex `(?<=ERROR |INFO )` mencari setiap baris yang memiliki kata dari (`ERROR |INFO `) dan `?<=` sebagai *PositiveLookahead* atau melihat kedepan dari kata tersebut. Regex `.+` menerima semua character sampai akhir line. Regex `(?= \()` untuk stop `.+` sampai bertemu ` (`.
```
#User
regex3="(?<=\()\w+\.?\w+"
```
Regex `(?<=\()` mencari setiap baris yang memiliki symbol `(` kemudian seperti sebelumnya `?<=` sebagai *PositiveLookahead* atau melihat kedepan dari kata tersebut. Regex `\w+` mencari satu kata dan `\.?` mencari titik jika ada ditambah, jika tidak ada juga boleh.
```
#Combined
regex4="(ERROR|INFO).+(?= \() |(?<=\()\w+\.?\w+)"
```
Setelah itu dijadikan satu, karena kata `(ERROR|INFO)` masuk maka tidak diperlukan `(?<=ERROR |INFO )`.

### **Jawaban No. 1B**

```bash
#soal 1B
#semua msg Error (Error tidak masuk) sampai bertemu ' ('
grep -oP '(?<=ERROR ).+(?= \()' syslog.log | sort | uniq -c
```
### **Penjelasan No. 1B**

Pada soal 1B diminta menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.
```
#semua msg Error (Error tidak masuk) sampai bertemu ' ('
grep -oP '(?<=ERROR ).+(?= \()' syslog.log | sort | uniq -c
```
Kode `grep -oP` berarti mengambil cuman kata yang dicari dalam baris dengan menggunakan syntax Perl regexp. Regex `(?<=ERROR ).+(?= \()` sama seperti regex2 akan tetapi hanya kata ERROR. Kode `| sort | uniq -c` melakukan *sort* agar pesan *log ERROR* yang sama berurutan kemudian dihitung berapa setiap user mendapat pesan ERROR.


### **Jawaban No. 1C**

```bash
#soal 1C
printf "Username,INFO,ERROR/n"
#Pertama ambil semua user
username=($(grep -oP '(?<=()w+.?w+' syslog.log | sort | uniq))
#Mengambil semua Error
E=$(grep -oP 'ERROR.+' syslog.log)
#Mengambil semua INFO
I=$(grep -oP 'INFO.+' syslog.log)

#Melakukan looping agar dengan menghitung username di dalam 
for i in "${!username[@]}"
do
    usertemp="${username[$i]}"
    In=$(grep -c $usertemp <<< "$I")
    Er=$(grep -c $usertemp <<< "$E")
    printf "%s,%d,%d\n" "$usertemp" "$In" "$Er"
done
```

### **Penjelasan No. 1C**

Pada soal 1C diminta menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap *user*-nya.
```
printf "Username,INFO,ERROR/n"
```
Melakukan output `Username,INFO,ERROR` agar mengetahui format yang ditampilkan.
```
#Pertama ambil semua user
username=($(grep -oP '(?<=()w+.?w+' syslog.log | sort | uniq))
```
Kode `grep -oP '(?<=()w+.?w+' syslog.log | sort | uniq` seperti pada no 1C mengambil semua *user* akan tetapi tidak dihitung hanya mengambil *user* yang tidak sama dan `($())` untuk dapat disimpan sebagai array.
```
#Melakukan looping agar dengan menghitung username di dalam 
#Error dan Info dan memasuki dalam csv
for i in "${!username[@]}"
do
    usertemp="${username[$i]}"
    In=$(grep -c $usertemp <<< "$I")
    Er=$(grep -c $usertemp <<< "$E")
    printf "%s,%d,%d\n" "$usertemp" "$In" "$Er" >> "user_statistic.csv"
done
```
Dilakukan for loop dengan `i` sebagai index. Kode `usertemp="${username[$i]}"` array ke index `i` disimpan ke variable baru. Kode `In=$(grep -c $usertemp <<< "$I")` menghitung berapa dari log INFO yang ada user tersebut. Kode `Er=$(grep -c $usertemp <<< "$E")` menghitung berapa dari log ERROR yang ada user tersebut. Kode `printf "%s,%d,%d\n" "$usertemp" "$In" "$Er"` menampilakan *user*,jumlah info,jumlah error.

### **Jawaban No. 1D**

```bash
#masukan header
printf "Error,Count\n" > "error_message.csv"
#memasuki Error message dan angka dalam array
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
```

### **Penjelasan No. 1D**

Pada soal 1D diminta untuk memasuki informasi pada poin b ke dalam file *error_message.csv* dengan format khusus.
```
#masukan header
printf "Error,Count\n" > "error_message.csv"
```
Kode diatas memasukan `Error,Count` sebagai header dari file csv.
```
#memasuki Error message dan angka dalam array
temp=($(grep -oP '(?<=ERROR ).+(?= ()' syslog.log | sort | uniq -c | sort -nr))
```
Regex `(?<=ERROR ).+(?= \()` sama seperti regex2 akan tetapi hanya kata ERROR. Kode `| sort | uniq -c` melakukan *sort* agar *user* yang sama berurutan kemudian dihitung berapa setiap user mendapat pesan ERROR. Kode `| sort -nr` melakukan *sort* dari jumlah terbanyak ke jumlah terdikit. Kode `($())` menyimpan dalam bentuk array.
```
#angka
re='^[0-9]+$'
it=-1
one=1
```
Variable - variable yang digunakan dalam looping nanti. `it` sebagai iterator tambahan. `re` representative dari angka. `one` satu.
```
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
```
Dilakukan for loop dengan nested if agar dapat memenuhi format output yang diinginkan.
```
if ! [[ "${temp[$i]}" =~ $re ]]
        then
        #tambah substring pada array ke $it
        words[$it]+="${temp[$i]}"
        if ! [[ "${temp[$i+$one]}" =~ $re ]]
             then
             #tambah substring pada array ke $it
             words[$it]+=" "
        fi
```
Jika `${temp[$i]}` bukan angka maka menambahkan string `${temp[$i]}` ke `words[$it]`. Kemudian dicek lagi menggunakan if, jika `${temp[$i+$one]}` yaitu satu diatas `${temp[$i]}`, bukan angka maka menambahkan string ` `.
```
else
    #jika ketemu angka
    it=$it+$one
    numbers[$it]="${temp[$i]}"
    fi
```
Jika tidak memenuhi if maka `it` sebagai iterator dijumlah dan memasuki angka pada array `numbers[$it]`. Variable `it` awal - awal -1 karena awal dari array `${temp[$i]}` merupakan angka.
```
#memasukan data pada csv
for i in "${!words[@]}"
    do
    sentence="${words[$i]}"
    number="${numbers[$i]}"
    printf "%s,%d\n" "$sentence" "$number" >> "error_message.csv"
done
```
Kemudian dilakukan for loop untuk memasuki kalimat dan angka ke dalam `error_message.csv` sesuai format yang diminta.

### **Jawaban No. 1E**

```bash
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
```

### **Penjelasan No. 1E**
Pada soal 1E diminta untuk memasuki informasi pada poin c ke dalam file `user_statistic.csv` dengan header `**Username,INFO,ERROR**` diurutkan berdasarkan username secara *ascending*.
```
printf "Username,INFO,ERROR/n" > "user_statistic.csv"
```
Kode ini memasuki `**Username,INFO,ERROR**` ke dalam file `user_statistic.csv` sebagai header.
```
#Pertama ambil semua user
username=($(grep -oP '(?<=()w+.?w+' syslog.log | sort | uniq))
```
Kode `grep -oP '(?<=()w+.?w+' syslog.log | sort | uniq` seperti pada no 1C mengambil semua *user* akan tetapi tidak dihitung hanya mengambil *user* yang tidak sama dan `($())` untuk dapat disimpan sebagai array.
```
#Melakukan looping agar dengan menghitung username di dalam 
#Error dan Info dan memasuki dalam csv
for i in "${!username[@]}"
do
    usertemp="${username[$i]}"
    In=$(grep -c $usertemp <<< "$I")
    Er=$(grep -c $usertemp <<< "$E")
    printf "%s,%d,%d\n" "$usertemp" "$In" "$Er" >> "user_statistic.csv"
done
```
Dilakukan for loop dengan `i` sebagai index. Kode `usertemp="${username[$i]}"` array ke index `i` disimpan ke variable baru. Kode `In=$(grep -c $usertemp <<< "$I")` menghitung berapa dari log INFO yang ada user tersebut. Kode `Er=$(grep -c $usertemp <<< "$E")` menghitung berapa dari log ERROR yang ada user tersebut. Kode `printf "%s,%d,%d\n" "$usertemp" "$In" "$Er" >> "user_statistic.csv"` memasuki semua data yang diperlukan pada `user_statistic.csv`.

### **Soal No. 2**

Steven dan Manis mendirikan sebuah *startup* bernama “TokoShiSop”. Sedangkan kamu dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja, Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan “*Laporan-TokoShiSop.tsv*”.

**a.** Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui **Row ID** dan **profit percentage** terbesar (jika hasil *profit percentage* terbesar lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari *profit percentage*, yaitu:

```text
Profit Percentage = (Profit / Cost Price) * 100
```

*Cost Price* didapatkan dari pengurangan *Sales* dengan *Profit*. (**Quantity diabaikan**).

**b.** Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM. Oleh karena itu, Clemong membutuhkan daftar **nama *customer* pada transaksi tahun 2017 di Albuquerque.**

**c.** TokoShiSop berfokus tiga *segment customer*, antara lain: *Home Office, Customer*, dan *Corporate*. Clemong ingin meningkatkan penjualan pada segmen *customer* yang paling sedikit. Oleh karena itu, Clemong membutuhkan ***segment customer*** dan **jumlah transaksinya yang paling sedikit.**

**d.** TokoShiSop membagi wilayah bagian (*region*) penjualan menjadi empat bagian, antara lain: *Central, East, South*, dan *West*. Manis ingin mencari **wilayah bagian (region) yang memiliki total keuntungan (*profit*) paling sedikit** dan **total keuntungan wilayah tersebut.**

Agar mudah dibaca oleh Manis, Clemong, dan Steven, **(e)** kamu diharapkan bisa membuat sebuah script yang akan menghasilkan file “hasil.txt” yang memiliki format sebagai berikut:

```text
Transaksi terakhir dengan profit percentage terbesar yaitu *ID Transaksi* dengan persentase *Profit Percentage*%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:

*Nama Customer1*

*Nama Customer2*

dst

Tipe segmen customer yang penjualannya paling sedikit adalah *Tipe Segment* dengan *Total Transaksi* transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah *Nama Region* dengan total keuntungan *Total Keuntungan (Profit)*
```

**Catatan** :

- Gunakan bash, AWK, dan command pendukung
- Script pada poin (e) memiliki nama file ‘soal2_generate_laporan_ihir_shisop.sh’

### **Jawaban No. 2**

Untuk menyelesaikan masalah yang ada pada nomer 2 di atas akan menggunakan program `AWK`. Langkah pertamanya adalah menentukan file separator (pemisah antar data) yang digunakan pada file yang berisi data yang akan diproses menggunakan awk.

```bash
BEGIN { FS = "\t" ;}
```
Kode di atas digunakan untuk mendefinisikan file separator, dengan memasukkan file separator yang digunakan ke dalam variabel `FS`.

### **Penjelasan Soal No. 2a**

Pada nomor 2a diminta untuk mencari dan menampilkan `ID Transaksi` dan `Profit Percentage terbesar` dalam data yang ada di file laporan. 

```bash
#Nomer 2a 
{ temppp = ($21/($18-$21))*100;
  if(maxpp<temppp) {
    maxpp = temppp;
    maxid = $2;
    maxrow = $1;
  }
  if(maxpp == temppp) {
    if(maxrow<$1) { 
      maxrow = $1;
      maxid = $2;
    }
  }
}
```

Kode di atas digunakan untuk mencari `Profit Percentage` tiap baris nya dan menyimpan data dengan nilai terbesar. Variabel `Temppp` digunakan untuk mencari nilai `Profit Percentage` pada tiap baris datanya. Lalu di bawahnya akan ada percabangan yang akan menentukan nilai terbesarnya dan jika nilai terbesarnya sama maka akan mengambil nilai dari `Row ID` terbesar. Lalu kode di bawah ini untuk menampilkan hasilnya.

```bash
#Soal 2a
printf("Transaksi terakhir dengan profit percentage terbesar yaitu %s dengan persentase %.2f%%\n\n",maxid,maxpp);
```

### **Penjelasan Soal No. 2b**

Pada soal nomor 2b diminta untuk mencari dan menampilkan daftar `Customer` yang melakukan transaksi di `Albuquerque`.

```bash
#Nomer 2b
/2017/ {
  if($10 == "Albuquerque"){
    samename = 0;
    for(itr = 0; itr < jml2017 ; itr++){
      if(custname[itr] == $7) samename = 1;
    }
    if(samename == 0) custname[jml2017++] = $7;
  }
}
```
Untuk mencarinya bisa dimulai dengan mengecek tahun order nya apakah sama dengan `2017` kebetulan di `Order ID` nya terdapat tahun ordernya jadi memudahkan untuk mengecek waktu transaksinya, kemudian mengecek apakah tempat transaksi tersebut berada di `Albuquerque` pada variable `$10`. Jika ditemukan maka akan masuk ke pengecekan apakah nama customer nya sudah masuk dalam daftar. Jika nama `Customer` belum masuk maka akan dimasukkan ke dalam array yang menampung daftar namanya. Lalu untuk menampilkannya dengan menggunakan kode dibawah ini.

```bash
#Soal 2b
printf("Daftar nama customer di Albuquerque pada tahun 2017 antara lain: \n");
for(itr = 0 ; itr < jml2017; itr++) printf("%s\n",custname[itr]);
printf("\n");
```

### **Penjelasan Soal No. 2c**

Pada soal nomor 2c diminta untuk mencari dan menampilkan `Segment Customer` dengan jumlah transaksi paling sedikit.

```bash
#Nomer 2c
/Home Office/ { homof++ }
/Corporate/ { corp++ }
/Consumer/ { consu++ }
```

Kode di atas digunakan untuk menghitung data yang termasuk pada salah satu dari ketiga segment customer yang ada, yaitu `Home Office`, `Corporate`, dan `Costumer`. Lalu untuk menampilkannya dengan menggunakan kode berikut ini.

```bash
#Soal 2c
if(homof < corp){
  if(homof < consu) { minseg = "Home Office"; mintotseg = homof; }
  else {minseg = "Customer"; mintotseg = consu; }
}
else{
  if(corp < consu) { minseg = "Corporate"; mintotseg = corp; }
  else {minseg = "Customer"; mintotseg = consu; }
}
printf("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n",minseg,mintotseg);
```

Sebelum ditampilkan akan masuk dalam percabangan untuk menentukan segment customer yang memiliki jumlah transaksi paling sedikit.

### **Penjelasan Soal No. 2d**

Pada soal nomor 2d diminta untuk mencari dan menampilkan `Region` (Wilayah) dengan total `Profit` (Keuntungan) paling sedikit.

```bash
#Nomer 2d
/Central/ { central += $21 }
/East/ { east += $21 }
/South/ { south += $21 }
/West/ { west += $21 }
```

Kode di atas digunakan untuk mencari total `Profit` pada setiap Region, caranya dengan menjumlahkan profit yang ada di variable `$21` ke dalam setiap variable penampungnya. Lalu akan ditampilkan dengan kode berikut ini.

```bash
#Soal 2d  
if(central < east){
  if(central < south){
    if(central < west){ minregion = "Central"; minprofregion = central; }
    else { minregion = "West"; minprofregion = west; }
  }
  else {
    if(south < west) { minregion = "South"; minprofregion = south; }
    else { minregion = "West"; minprofregion = west; }
  }
}
else {
  if(east < south) {
    if(east < west) { minregion = "East"; minprofregion = east; }
    else { minregion = "West"; minprofregion = west; }
  }
  else {
    if(south < west) { minregion = "South"; minprofregion = south; }
    else { minregion = "West"; minprofregion = west; }
  }
}
printf("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %f\n",minregion,minprofregion);
```

Sebelum ditampilkan akan masuk dalam percabangan untuk menentukan Region mana yang memiliki Profit paling sedikit.


### **Penjelasan Soal No. 2e**

Soal nomor 2e merupakan script yang akan di jalankan untuk menyelesaikan problem yang ada pada soal 2a-2d dengan menggunakan kode berikut. 

```bash
#!/bin/bash

# Soal 2
awk 'BEGIN { FS = "\t" ;}
#Nomer 2a 
{ temppp = ($21/($18-$21))*100;
  if(maxpp<temppp) {
    maxpp = temppp;
    maxid = $2;
    maxrow = $1;
  }
  if(maxpp == temppp) {
    if(maxrow<$1) { 
      maxrow = $1;
      maxid = $2;
    }
  }
}
#Nomer 2b
/2017/ {
  if($10 == "Albuquerque"){
    samename = 0;
    for(itr = 0; itr < jml2017 ; itr++){
      if(custname[itr] == $7) samename = 1;
    }
    if(samename == 0) custname[jml2017++] = $7;
  }
}
#Nomer 2c
/Home Office/ { homof++ }
/Corporate/ { corp++ }
/Consumer/ { consu++ }
#Nomer 2d
/Central/ { central += $21 }
/East/ { east += $21 }
/South/ { south += $21 }
/West/ { west += $21 }
END { 
#Soal 2a
   printf("Transaksi terakhir dengan profit percentage terbesar yaitu %s dengan persentase %.2f%%\n\n",maxid,maxpp);
#Soal 2b
   printf("Daftar nama customer di Albuquerque pada tahun 2017 antara lain: \n");
  for(itr = 0 ; itr < jml2017; itr++) printf("%s\n",custname[itr]);
  printf("\n");
#Soal 2c
  if(homof < corp){
    if(homof < consu) { minseg = "Home Office"; mintotseg = homof; }
    else {minseg = "Customer"; mintotseg = consu; }
  }
  else{
    if(corp < consu) { minseg = "Corporate"; mintotseg = corp; }
    else {minseg = "Customer"; mintotseg = consu; }
  }
  printf("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n",minseg,mintotseg);
#Soal 2d  
  if(central < east){
    if(central < south){
      if(central < west){ minregion = "Central"; minprofregion = central; }
      else { minregion = "West"; minprofregion = west; }
    }
    else {
      if(south < west) { minregion = "South"; minprofregion = south; }
      else { minregion = "West"; minprofregion = west; }
    }
  }
  else {
    if(east < south) {
      if(east < west) { minregion = "East"; minprofregion = east; }
      else { minregion = "West"; minprofregion = west; }
    }
    else {
      if(south < west) { minregion = "South"; minprofregion = south; }
      else { minregion = "West"; minprofregion = west; }
    }
  }
  printf("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %f\n",minregion,minprofregion);
}
' Laporan-TokoShiSop.tsv > hasil.txt
```

Kode di atas akan dijalankan dengan menggunakan perintah bash pada terminal dan akan menghasilnya file `hasil.txt` yang merupakan solusi dari soal 2a-2d. Perintahnya adalah sebagai berikut.

```bash
bash soal2_generate_laporan_ihir_shisop.sh
```

### **Soal No. 3**

Kuuhaku adalah orang yang sangat suka mengoleksi foto-foto digital, namun Kuuhaku juga merupakan seorang yang pemalas sehingga ia tidak ingin repot-repot mencari foto, selain itu ia juga seorang pemalu, sehingga ia tidak ingin ada orang yang melihat koleksinya tersebut, sayangnya ia memiliki teman bernama Steven yang memiliki rasa kepo yang luar biasa. Kuuhaku pun memiliki ide agar Steven tidak bisa melihat koleksinya, serta untuk mempermudah hidupnya, yaitu dengan meminta bantuan kalian. Idenya adalah :

**a.** Membuat script untuk **mengunduh** 23 gambar dari "https://loremflickr.com/320/240/kitten" serta **menyimpan** log-nya ke file "Foto.log". Karena gambar yang diunduh acak, ada kemungkinan gambar yang sama terunduh lebih dari sekali, oleh karena itu kalian harus **menghapus** gambar yang sama (tidak perlu mengunduh gambar lagi untuk menggantinya). Kemudian **menyimpan** gambar-gambar tersebut dengan nama "Koleksi_XX" dengan nomor yang berurutan **tanpa ada nomor yang hilang** (contoh : Koleksi_01, Koleksi_02, ...)

**b.** Karena Kuuhaku malas untuk menjalankan script tersebut secara manual, ia juga meminta kalian untuk menjalankan script tersebut **sehari sekali pada jam 8 malam** untuk tanggal-tanggal tertentu setiap bulan, yaitu dari **tanggal 1 tujuh hari sekali** (1,8,...), serta dari **tanggal 2 empat hari sekali**(2,6,...). Supaya lebih rapi, gambar yang telah diunduh beserta **log-nya, dipindahkan ke folder** dengan nama **tanggal unduhnya** dengan **format** "DD-MM-YYYY" (contoh : "13-03-2023").

**c.** Agar kuuhaku tidak bosan dengan gambar anak kucing, ia juga memintamu untuk **mengunduh** gambar kelinci dari "https://loremflickr.com/320/240/bunny". Kuuhaku memintamu mengunduh gambar kucing dan kelinci secara **bergantian** (yang pertama bebas. contoh : tanggal 30 kucing > tanggal 31 kelinci > tanggal 1 kucing > ... ). Untuk membedakan folder yang berisi gambar kucing dan gambar kelinci, **nama folder diberi awalan** "Kucing_" atau "Kelinci_" (contoh : "Kucing_13-03-2023").

**d.** Untuk mengamankan koleksi Foto dari Steven, Kuuhaku memintamu untuk membuat script yang akan **memindahkan seluruh folder ke zip** yang diberi nama “Koleksi.zip” dan **mengunci** zip tersebut dengan **password** berupa tanggal saat ini dengan format "MMDDYYYY" (contoh : “03032003”).

**e.** Karena kuuhaku hanya bertemu Steven pada saat kuliah saja, yaitu setiap hari kecuali sabtu dan minggu, dari jam 7 pagi sampai 6 sore, ia memintamu untuk membuat koleksinya **ter-zip** saat kuliah saja, selain dari waktu yang disebutkan, ia ingin koleksinya **ter-unzip** dan **tidak ada file zip** sama sekali.

**Catatan** :
- Gunakan bash, AWK, dan command pendukung
- Tuliskan semua cron yang kalian pakai ke file cron3[b/e].tab yang sesuai

### **Jawaban No. 3a**

```bash
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

# Iterasi sampai maks 23
maks_iterasi=23
file_ke=1
while [ "$file_ke" -le "$maks_iterasi" ]
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
        echo "$filename: Hasil download sama, hapus."
        maks_iterasi=$(($maks_iterasi - 1))
        rm "./$filename"
    else
        echo "$filename: Hasil download berbeda, lanjut."
        file_ke=$(($file_ke + 1)) 
    fi
done

# Done
echo "Sudah terdownload semua"
```
![Soal 3a Terminal](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3a-terminal.webp)
![Soal 3a File](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3b-file.webp)

### **Penjelasan No. 3a**

```bash
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"
```

Kode ini berfungsi untuk mencari path dari file *script* ini lalu berpindah ke directory itu. Hal ini bertujuan agar *script* tidak mendownload file di directory yang tidak diharapkan.

```bash
get_file_name_result=""
get_file_name() {
    if [ $1 -lt 10 ]
    then
        get_file_name_result="Koleksi_0$1"
    else
        get_file_name_result="Koleksi_$1"
    fi
}
```

Fungsi `get_file_name()` digunakan untuk menentukan nama berkas dari angka iterasi yang dimasukkan berdasarkan digit dari angkanya. Apabila 1 digit, maka berkas akan bernama "Koleksi_0X", sedangkan "Koleksi_XX" untuk 2 digit. Nama berkas tersebut akan dimasukkan ke variabel `get_file_name_result` agar dapat digunakan selama jalannya *script*.

```bash
# Iterasi sampai maks 23
maks_iterasi=23
file_ke=1
while [ "$file_ke" -le "$maks_iterasi" ]
do
    # Blok kode yang akan dijelaskan selanjutnya
done
```

Potongan kode di atas digunakan untuk looping penomoran berkas dari 1 hingga 23.

Berikutnya akan dijelaskan blok kode pada loop tersebut.

```bash
get_file_name "$file_ke"
filename=$get_file_name_result
wget -O "$filename" -a Foto.log https://loremflickr.com/320/240/kitten
```

Potongan kode ini bertujuan untuk memanggil fungsi `get_file_name()` dengan parameter variabel iterasi `file_ke` untuk mendapatkan `filename` yaitu nama berkas yang akan didownload. Setelah itu, panggil wget dengan nama berkas `filename`, *append log*-nya ke berkas "Foto.log" dari link <https://loremflickr.com/320/240/kitten>

```bash
is_same=0
awk_link_array=($(awk '/https:\/\/loremflickr.com\/cache\/resized\// {print $3}' ./Foto.log))
awk_array_length=(${#awk_link_array[@]})
```

Blok ini bertujuan untuk memeriksa link download berkas menggunakan awk dengan regex `/https:\/\/loremflickr.com\/cache\/resized\//` lalu print `$3`-nya dan memasukkan hasil awk-nya ke array `awk_link_array`. Setelah itu, ambil panjang array tersebut dan masukkan ke variabel `awk_array_length`.

```bash
for((i=0; i < ($awk_array_length - 1); i++))
do
    if [ "${awk_link_array[i]}" == "${awk_link_array[$(($awk_array_length - 1))]}" ]
    then
        is_same=1
        break
    fi
done
```

Blok loop ini akan memeriksa link download yang telah disimpan pada array dengan membandingkan link download terbaru dengan seluruh isi array hingga indeks tepat sebelumnya. Apabila ada link yang sama, maka blok `if` bertujuan untuk mengisi variabel `is_same` dengan 1 yang menandakan true, lalu hentikan blok `for` karena sudah terdeteksi kesamaan berkas.

```bash
if [ $is_same -eq 1 ]
then
    echo "$filename: Hasil download sama, hapus."
    maks_iterasi=$(($maks_iterasi - 1))
    rm "./$filename"
else
    echo "$filename: Hasil download berbeda, lanjut."
    file_ke=$(($file_ke + 1)) 
fi
```

Blok kode ini bertujuan membaca variabel `is_same` sebelumnya, apabila bernilai 1 yang bermakna ada berkas sama yang sebelumnya telah didownload, maka hapus berkas yang baru didownload dengan `rm "./$filename"` dan kurangi batas maksimal  looping yaitu `maks_iterasi`. Sebaliknya, variabel iterasi `file_ke` ditambahkan 1 yang berarti lanjut ke koleksi nomor berikutnya.

### **Jawaban No. 3b (bash)**

```bash
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
```
![Soal 3b Terminal](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3b-terminal.webp)
![Soal 3b File](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3b-file.webp)
![Soal 3b Crontab](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3b-crontab.webp)

### **Penjelasan No. 3b (bash)**

```bash
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"
```

Kode ini berfungsi untuk mencari path dari berkas *script* ini lalu berpindah ke directory itu. Hal ini bertujuan agar crontab tidak mendownload berkas di directory yang tidak diharapkan.

```bash
bash ./soal3a.sh
```

Potongan kode ini akan memanggil kode untuk soal no. 3a yang akan mendownload berkas-berkas sesuai perintah soal.

```bash
current_date=$(date +"%d-%m-%Y")
mkdir "$current_date"
mv ./Koleksi_* "./$current_date/"
mv ./Foto.log "./$current_date/"
```

Potongan kode ini bertujuan mengambil informasi tanggal hari ini dengan format "DD-MM-YYYY" dan menyimpannya ke variabel `current_date` yang kemudian digunakan untuk membuat folder dengan nama `$current_date` dan memindahkan berkas-berkas Koleksi serta Foto.log ke folder tersebut.

### **Jawaban No. 3b (crontab)**

```crontab
0 20 1-31/7,2-31/4 * * bash ~/soal-shift-sisop-modul-1-F06-2021/soal3/soal3b.sh
```

### **Penjelasan No. 3b (crontab)**

*Script* cron di atas bertujuan untuk mengeksekusi *script* `soal3b.sh` **sehari sekali pada jam 8 malam** untuk tanggal-tanggal tertentu setiap bulan, yaitu dari **tanggal 1 tujuh hari sekali** (1,8,...), serta dari **tanggal 2 empat hari sekali** (2,6,...).

### **Jawaban No. 3c**

```bash
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

# Iterasi sampai maks 23
maks_iterasi=23
file_ke=1
while [ "$file_ke" -le "$maks_iterasi" ]
do

    # Tentukan filename dulu
    get_file_name "$file_ke"
    filename=$get_file_name_result
    wget -O "$filename" -a Foto.log "https://loremflickr.com/320/240/$link_download"

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
        echo "$filename: Hasil download sama, hapus."
        maks_iterasi=$(($maks_iterasi - 1))
        rm "./$filename"
    else
        echo "$filename: Hasil download berbeda, lanjut."
        file_ke=$(($file_ke + 1)) 
    fi
done

# Done download
echo "Sudah terdownload semua"

# Bikin folder, lalu dipindah ke folder itu
mkdir "$nama_folder"
mv ./Koleksi_* "./$nama_folder/"
mv ./Foto.log "./$nama_folder/"

# Sudah dipindahkan
echo "Moved to $nama_folder"
```

![Soal 3c Terminal Kelinci](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3c-terminal-kelinci.webp)
![Soal 3c Terminal Kucing](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3c-terminal-kucing.webp)
![Soal 3c File](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3c-file.webp)

### **Penjelasan No. 3c**

Sebetulnya *script* pada **3c** ini mirip dengan **3a**, oleh karena itu disini akan dijelaskan perubahannya saja.

```bash
kemarin=$(date -d yesterday +"%d-%m-%Y")
current_date=$(date +"%d-%m-%Y")
```

Potongan kode ini bertujuan untuk mendapatkan informasi dan memformat "DD-MM-YYYY' mengenai tanggal kemarin dan hari ini.

```bash
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
```

Potongan kode ini akan memeriksa apakah ada folder kucing di hari kemarin atau folder dengan nama `Kucing_$kemarin`. Jika ada maka, sekarang download kelinci, assign `link_download` dengan "bunny" dan `nama_folder` dengan `"Kelinci_$current_date"`. Sebaliknya, assign `link_download` dengan "kitten" dan `nama_folder` dengan `"Kucing_$current_date"`.

Blok while pada jawaban no. **3a** hanya mengalami perubahan pada parameter wget sebagai berikut:

```bash
wget -O "$filename" -a Foto.log "https://loremflickr.com/320/240/$link_download"
```

Perubahannya adalah mengganti link yang secara statis mengarah ke "kitten" menjadi dinamis mengikuti variabel `link_download`.

```bash
mkdir "$nama_folder"
mv ./Koleksi_* "./$nama_folder/"
mv ./Foto.log "./$nama_folder/"
```

Potongan kode ini akan membuat folder baru dengan nama sesuai variabel `nama_folder` dan memindahkan semua koleksi serta Foto.log ke folder tersebut.

### **Jawaban No. 3d**

```bash
#!/bin/bash

# Masuk ke folder repo dulu
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"

# Ambil tanggal hari ini
hariini=$(date +"%m%d%Y")

# Zip file-filenya
zip -rem Koleksi.zip Kucing_* Kelinci_* -P "$hariini"
```

![Soal 3d Terminal](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3d-terminal.webp)
![Soal 3d File](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3d-file.webp)

### **Penjelasan No. 3d**

```bash
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"
```

Kode ini berfungsi untuk mencari path dari file *script* ini lalu berpindah ke directory itu. Hal ini bertujuan agar *script* melakukan zip file pada directory yang sama dengan *script*-nya.

```bash
hariini=$(date +"%m%d%Y")
```

Potongan kode ini mengambil informasi tanggal hari ini dengan format "DDMMYYYY" dan menyimpannya ke variabel `hariini`.

```bash
zip -rem Koleksi.zip Kucing_* Kelinci_* -P "$hariini"
```

Potongan kode ini akan memasukkan semua folder kucing maupun kelinci ke dalam zip dengan nama "Koleksi.zip" dengan password sesuai variabel `hariini` lalu menghapus folder-folder *original*-nya.

### **Revisi No. 3d**
Terbalik antara "%m%d%Y" dan "%d%m%Y", solusinya tinggal membaliknya.

### **Jawaban No. 3e**

```crontab
# Zip saat kuliah
0 7 * * 1-5 bash ~/soal-shift-sisop-modul-1-F06-2021/soal3/soal3d.sh

# Unzip saat tidak kuliah
0 18 * * 1-5 unzip -P "$(date +"%m%d%Y")" ~/soal-shift-sisop-modul-1-F06-2021/soal3/Koleksi.zip -d ~/soal-shift-sisop-modul-1-F06-2021/soal3/ && rm ~/soal-shift-sisop-modul-1-F06-2021/soal3/Koleksi.zip
```

### **Revisi No. 3e**
Terbalik antara "%m%d%Y" dan "%d%m%Y", solusinya tinggal membaliknya.

### **Penjelasan No. 3e**

*Script* cron di atas bertujuan untuk mengeksekusi *script* `soal3d.sh` **setiap hari kecuali sabtu dan minggu, dari jam 7 pagi sampai 6 sore** dan melakukan unzip serta hapus zip **selain waktu-waktu tersebut**.

![Soal 3e Crontab compress](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3e-crontab.webp)
![Soal 3e Crontab](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3e-crontab-compress.webp)
![Soal 3e terminal](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3e-terminal.webp)
![Soal 3e File](https://storage.googleapis.com/zydhan-web.appspot.com/soal-3e-file.webp)

### **Catatan tambahan untuk No. 3**

- Semua perintah `echo` bertujuan untuk memberikan *feedback* ke pengguna mengenai apa yang sedang terjadi pada *script* sehingga *script* tidak menampilkan output yang kurang *user-friendly*.
- Newline yang ada pada akhir file crontab tidak terbaca pada github.
