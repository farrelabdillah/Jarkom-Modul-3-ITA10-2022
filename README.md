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

# **Soal Shift: DHCP**
- Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server.
- Client yang melalui Switch1 mendapatkan range IP dari [prefix IP].1.50 - [prefix IP].1.88 dan [prefix IP].1.120 - [prefix IP].1.155 
- Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.10 - [prefix IP].3.30 dan [prefix IP].3.60 - [prefix IP].3.85 
- Client mendapatkan DNS dari WISE dan client dapat terhubung dengan internet melalui DNS tersebut.
- Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 5 menit sedangkan pada client yang melalui Switch3 selama 10 menit. Dengan -     waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 115 menit. 

# **Langkah Pengerjaan: DHCP**
- Menginstall isc-dhcp-relay pada Ostania untuk membuatnya menjadi DHCP Relay.
  <br>
  <img src="Screenshot/6.PNG">
  <br>
  <br>
  dan Menambahkan:
  ```
  SERVERS="192.214.2.4"
  INTERFACES="eth1 eth2 eth3"
  OPTIONS=""
  ```
  pada /etc/default/isc-dhcp-relay.
  <br>
  <br>
  Setelah itu, melakukan ```service isc-dhcp-relay restart``` untuk mengonfirmasi perubahan pada relay.
  <br>
- Menginstall isc-dhcp-server pada Westalis untuk membuatnya menjadi DHCP Server.
  <br>
  <img src="Screenshot/7.PNG">
  <br>
  <br>
  dan Menambahkan ```INTERFACES="eth0"``` pada /etc/default/isc-dhcp-server
  <br>
- pada /etc/dhcp/dhcpd.conf, akan ditambahkan config untuk menjalankan relay yaitu:
  ```
  subnet 192.214.2.0 netmask 255.255.255.0 {}
  ```
  <br>
  Peminjaman IP akan dilakukan dengan waktu default dan maximum tertentu yang telah diarahkan ke IP WISE (192.214.2.2).
  Untuk melakukan hal tersebut, akan dilakukan penambahan config pada Switch1 dengan:
  
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
  Sementara pada Switch3 akan ditambahkan config:
  
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
 
  Melakukan ```service isc-dhcp-server restart``` untuk restart pada DHCP Server.
  
  <br>
- Untuk membuat semua user pada Switch1 dan Switch3 sesuai dengan DHCP Server, akan dilakukan perubahan pada setiap konfigurasinya menjadi:
  <br>
  <img src="Screenshot/8.PNG">
  <br>
- Dalam node WISE akan ditambahkan: 

  ```
  options {
    directory "/var/cache/bind";
 
    forwarders {
            192.168.122.1;
    };
 
    allow-query { any; };
 
    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
  };
  ``` 
  pada /etc/bind/named.conf.options
  <br>
  
  ```forwarders {ip}``` sendiri berguna sebagai DNS Forwarder kepada IP yang dituju.
  <br>
- Pada setiap DHCP client akan dilakukan testing IP, testing ini bertujuan untuk membuktikan bahwa setiap client mendapatkan IP yang sesuai dengan range yang telah       dibagikan oleh DHCP server dan mendapatkan akses internet lewat WISE (DNS Server) dengan IP yang sesuai yaitu 192.214.2.2. Contohnya adalah seperti ini: 
  <br>
  <img src="Screenshot/9.PNG">

# **Langkah Pengerjaan: Proxy**
SSS, Garden, dan Eden digunakan sebagai client Proxy agar pertukaran informasi dapat terjamin keamanannya, juga untuk mencegah kebocoran data. Pada Proxy Server di Berlint, Loid berencana untuk mengatur bagaimana Client dapat mengakses internet. Artinya setiap client harus menggunakan Berlint sebagai HTTP & HTTPS proxy. Adapun kriteria pengaturannya adalah sebagai berikut:
- Client hanya dapat mengakses internet diluar (selain) hari & jam kerja (senin-jumat 08.00 - 17.00) dan hari libur (dapat mengakses 24 jam penuh)
- Adapun pada hari dan jam kerja sesuai nomor (1), client hanya dapat mengakses domain loid-work.com dan franky-work.com (IP tujuan domain dibebaskan)
- Saat akses internet dibuka, client dilarang untuk mengakses web tanpa HTTPS. (Contoh web HTTP: http://example.com)
- Agar menghemat penggunaan, akses internet dibatasi dengan kecepatan maksimum 128 Kbps pada setiap host (Kbps = kilobit per second; lakukan pengecekan pada tiap host, ketika 2 host akses internet pada saat bersamaan, keduanya mendapatkan speed maksimal yaitu 128 Kbps)
- Setelah diterapkan, ternyata peraturan nomor (4) mengganggu produktifitas saat hari kerja, dengan demikian pembatasan kecepatan hanya diberlakukan untuk pengaksesan internet pada hari libur
<br>
<img src="Screenshot/Tabel.PNG">
