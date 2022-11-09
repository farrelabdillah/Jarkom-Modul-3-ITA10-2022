# Jarkom-Modul-3-ITA10-2022
**Laporan Resmi praktikum Jarkom kelompok ITA10**
<br>
Kelompok:
- Hafizh Abid Wibowo (5027201011)
- Muhammad Farrel Abdillah (50272010570)
<br>
Berikut adalah Dokumentasi dan langkah pengerjaan untuk laporan resmi praktikum jarkom modul 3
<br>

# **Konfigurasi: Topologi**
<img src="Screenshot/1.PNG">
<br>
 Berikut adalah screenshot konfigurasi dari node dalam topologi
 
 <br>
 WISE - DNS Server:
 <br>
 <img src="Screenshot/2.PNG">
 
 <br>
 Westalis - DHCP Server:
 <br>
 <img src="Screenshot/3.PNG">
 
 <br>
 Berlint - Proxy Server:
 <br>
 <img src="Screenshot/4.PNG">
 
 <br>
 Ostania - DHCP Relay:
 <br>
 <img src="Screenshot/5.PNG">
 
 <br>
 
# **Langkah Pengerjaan: DHCP**
-
-
-
-
-
-
-
-
-
-
-


# **Langkah Pengerjaan: Proxy**
SSS, Garden, dan Eden digunakan sebagai client Proxy agar pertukaran informasi dapat terjamin keamanannya, juga untuk mencegah kebocoran data. Pada Proxy Server di Berlint, Loid berencana untuk mengatur bagaimana Client dapat mengakses internet. Artinya setiap client harus menggunakan Berlint sebagai HTTP & HTTPS proxy. Adapun kriteria pengaturannya adalah sebagai berikut:
- Client hanya dapat mengakses internet diluar (selain) hari & jam kerja (senin-jumat 08.00 - 17.00) dan hari libur (dapat mengakses 24 jam penuh)
- Adapun pada hari dan jam kerja sesuai nomor (1), client hanya dapat mengakses domain loid-work.com dan franky-work.com (IP tujuan domain dibebaskan)
- Saat akses internet dibuka, client dilarang untuk mengakses web tanpa HTTPS. (Contoh web HTTP: http://example.com)
- Agar menghemat penggunaan, akses internet dibatasi dengan kecepatan maksimum 128 Kbps pada setiap host (Kbps = kilobit per second; lakukan pengecekan pada tiap host, ketika 2 host akses internet pada saat bersamaan, keduanya mendapatkan speed maksimal yaitu 128 Kbps)
- Setelah diterapkan, ternyata peraturan nomor (4) mengganggu produktifitas saat hari kerja, dengan demikian pembatasan kecepatan hanya diberlakukan untuk pengaksesan internet pada hari libur
<br>
<img src="Screenshot/Tabel.PNG">
