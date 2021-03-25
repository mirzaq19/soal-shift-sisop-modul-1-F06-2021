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

### **Jawaban No. 1**

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
Gunakan bash, AWK, dan command pendukung
Tuliskan semua cron yang kalian pakai ke file cron3[b/e].tab yang sesuai

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
```

### **Penjelasan No. 3a**

```bash
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"
```

Kode ini berfungsi untuk mencari path dari file script ini lalu berpindah ke directory itu. Hal ini bertujuan agar script tidak mendownload file di directory yang tidak diharapkan.

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
file_ke=1
while [ "$file_ke" -le 23 ]
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
```

Blok loop ini bertujuan untuk memeriksa berkas "Koleksi_01" hingga "Koleksi_(`file_ke - 1`)" dengan berkas yang baru didownload menggunakan cmp. cmp akan menghasilkan exit status 0 apabila berkas sama, maka blok `if` bertujuan untuk mengisi variabel `is_same` dengan 1 yang menandakan true, lalu hentikan blok `for` karena sudah terdeteksi kesamaan berkas.

```bash
if [ $is_same -eq 1 ]
then
    echo "$filename: Hasil download sama, hapus dan ulang."
    rm "./$filename"
else
    echo "$filename: Hasil download berbeda, lanjut."
    file_ke=$(($file_ke + 1)) 
fi
```

Blok kode ini bertujuan membaca variabel `is_same` sebelumnya, apabila bernilai 1 yang bermakna ada berkas sama yang sebelumnya telah didownload, maka hapus berkas yang baru didownload dengan `rm "./$filename"`. Sebaliknya, variabel iterasi `file_ke` ditambahkan 1 yang berarti lanjut ke koleksi nomor berikutnya.

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

### **Penjelasan No. 3b (bash)**

```bash
BASEDIR=$(dirname "$0")
echo "Masuk ke $BASEDIR"
cd "$BASEDIR"
```

Kode ini berfungsi untuk mencari path dari berkas script ini lalu berpindah ke directory itu. Hal ini bertujuan agar crontab tidak mendownload berkas di directory yang tidak diharapkan.

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

Script cron di atas bertujuan untuk mengeksekusi script `soal3b.sh` **sehari sekali pada jam 8 malam** untuk tanggal-tanggal tertentu setiap bulan, yaitu dari **tanggal 1 tujuh hari sekali** (1,8,...), serta dari **tanggal 2 empat hari sekali** (2,6,...).

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

# Done download
echo "Sudah terdownload semua"

# Bikin folder, lalu dipindah ke folder itu
mkdir "$nama_folder"
mv ./Koleksi_* "./$nama_folder/"
mv ./Foto.log "./$nama_folder/"

# Sudah dipindahkan
echo "Moved to $nama_folder"
```

### **Penjelasan No. 3c**

Sebetulnya script pada **3c** ini mirip dengan **3a**, oleh karena itu disini akan dijelaskan perubahannya saja.

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

# Ambil tanggal hari ini
hariini=$(date +"%d%m%Y")

# Zip file-filenya
zip -rem Koleksi.zip Kucing_* Kelinci_* -P "$hariini"
```

### **Penjelasan No. 3d**

```bash
hariini=$(date +"%d%m%Y")
```

Potongan kode ini mengambil informasi tanggal hari ini dengan format "DDMMYYYY" dan menyimpannya ke variabel `hariini`.

```bash
zip -rem Koleksi.zip Kucing_* Kelinci_* -P "$hariini"
```

Potongan kode ini akan memasukkan semua folder kucing maupun kelinci ke dalam zip dengan nama "Koleksi.zip" dengan password sesuai variabel `hariini` lalu menghapus folder-folder *original*-nya.

### **Jawaban No. 3e**

```bash
#!/bin/bash

# Ambil tanggal hari ini
hariini=$(date +"%d%m%Y")

# Unzip file-filenya
unzip -P "$hariini" Koleksi.zip

# Hapus file zip
rm ./Koleksi.zip
```

### **Penjelasan No. 3e**

```bash
hariini=$(date +"%d%m%Y")
```

Potongan kode ini mengambil informasi tanggal hari ini dengan format "DDMMYYYY" dan menyimpannya ke variabel `hariini`.

```bash
unzip -P "$hariini" Koleksi.zip
```

Potongan kode ini akan melakukan *extract* arsip "Koleksi.zip" dengan password sesuai variabel `hariini`.

```bash
rm ./Koleksi.zip
```

Potongan kode ini akan menghaous arsip "Koleksi.zip".

### **Catatan tambahan untuk No. 3**

- Semua perintah `echo` bertujuan untuk memberikan *feedback* ke pengguna mengenai apa yang sedang terjadi pada script sehingga script tidak menampilkan output yang kurang *user-friendly*.
- Newline yang ada pada akhir file crontab tidak terbaca pada github.
