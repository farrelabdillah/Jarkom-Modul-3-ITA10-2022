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
- Pada Westalis, menginstall isc-dhcp-relay dan namserver 192.214.0.3 akan dibuat sehingga dapat terhubung ke internet. 
  <br>
  <img src="Screenshot/9.PNG">
  <br>
  <br>
  Setelah itu menambahkan:
  
  ```INTERFACES="eth0"```
  pada /etc/default/isc-dhcp-server. 
  <br>
  <img src="Screenshot/8.PNG">
- Menjalankan relay dengan konfig:
  ```
  subnet 192.214.2.0 netmask 255.255.255.0 {}
  ```
  pada /etc/dhcp/dhcpd.conf
- Setelah itu, pada switch1 menambahkan konfig:
  ```
  subnet 192.214.1.0 netmask 255.255.255.0 {
    range 192.214.1.50 192.214.1.88;
    range 192.214.1.120 192.214.1.155;
    option routers 192.214.1.1;
    option broadcast-address 192.214.1.255;
    option domain-name-servers 192.214.2.2;
    default-lease-time 300;
    max-lease-time 6900;
  }
  ``` 
  pada /etc/dhcp/dhcpd.conf
  <br>
  Range diatur sesuai dengan yang diminta oleh soal. DNS diarahkan ke IP WISE yaitu 192.214.2.2 seperti yang tertulis diatas. Waktu default peminjaman alamat IP ke       client adalah 300 detik, sedangkan waktu maksimalnya adalah 6900 detik. 
- Setelah itu, pada switch3 menambahkan konfig:
  ```
  subnet 192.214.3.0 netmask 255.255.255.0 {
    range 192.214.3.10 192.214.3.30;
    range 192.214.3.60 192.214.3.85;
    option routers 192.214.3.1;
    option broadcast-address 192.214.1.255;
    option domain-name-servers 192.214.2.2;
    default-lease-time 600;
    max-lease-time 6900;
  }
  ``` 
  pada /etc/dhcp/dhcpd.conf
  <br>
  Range diatur sesuai dengan yang diminta oleh soal. DNS diarahkan ke IP WISE yaitu 192.214.2.2 seperti yang tertulis diatas. Waktu default peminjaman alamat IP ke       client adalah 600 detik, sedangkan waktu maksimalnya adalah 6900 detik.  
- Konfigurasi pada setiap client dengan konfigurasi IP sesuai dari DHCP Server:
  <br>
  <img src="Screenshot/6.PNG">
  <img src="Screenshot/7.PNG">
- Untuk membuat seluruh client dapat mengakses internet, pertama-tama akan diinstallkan bind9 pada WISE:
  <br>
  <img src="Screenshot/10.PNG">
- Lalu WISE akan ditambahkan: 
  ```
  options {
    directory "/var/cache/bind";
 
    forwarders {
            192.168.122.1;
    };
 
    allow-query { any; };
 
    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
  }
  ```
  di /etc/bind/named.conf.options agar WISE dapat mengakses internet.
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
