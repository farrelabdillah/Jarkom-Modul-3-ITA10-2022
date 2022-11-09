#!/bin/env bash

if [[ $(hostname) = "Ostania" ]]; then
    apt update
    apt install \
    isc-dhcp-relay -y

cat << EOS > /etc/default/isc-dhcp-relay
SERVERS="192.214.2.4"
INTERFACES="eth1 eth2 eth3"
OPTIONS=""
EOS

    service isc-dhcp-relay restart
    
elif [[ $(hostname) = "SSS" ]]; then
    apt update
    apt install \
    lynx \
    speedtest-cli -y
elif [[ $(hostname) = "Garden" ]]; then
    apt update
    apt install \
    lynx \
    speedtest-cli -y
elif [[ $(hostname) = "WISE" ]]; then
    apt update
    apt install \
    apache2 \
    bind9 -y

    cat << EOS > /etc/bind/named.conf.local
zone "loid-work.com" {
    type master;
    file "/etc/bind/jarkom/loid-work.com";
};

zone "franky-work.com" {
    type master;
    file "/etc/bind/jarkom/franky-work.com";
};
EOS

    cat << EOS > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
            192.168.122.1;
    };

    allow-query { any; };

    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
};
EOS

    mkdir -p /etc/bind/jarkom

    cat << EOS > /etc/bind/jarkom/loid-work.com
\$TTL   604800
@       IN      SOA     loid-work.com. root.loid-work.com. (
                        2022110701      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      loid-work.com.
@       IN      A       192.214.2.2
EOS

    cat << EOS > /etc/bind/jarkom/franky-work.com
\$TTL   604800
@       IN      SOA     franky-work.com. root.franky-work.com. (
                        2022110701      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      franky-work.com.
@       IN      A       192.214.2.2
EOS

    cat << EOS > /etc/apache2/sites-available/loid-work.com.conf
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ServerName loid-work.com
 
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOS

    cat << EOS > /etc/apache2/sites-available/franky-work.com.conf
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ServerName franky-work.com
 
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOS

    service apache2 start
    a2ensite loid-work.com.conf
    a2ensite franky-work.com.conf
    service apache2 restart
    service bind9 restart

elif [[ $(hostname) = "Berlint" ]]; then
    apt update
    apt install \
    squid -y

    cat << EOS > /etc/squid/squid.conf
include /etc/squid/acl-time.conf
include /etc/squid/acl-bandwidth.conf
include /etc/squid/acl-port.conf

http_port 8080
dns_nameservers 192.214.2.2

acl WORKING_HOUR_SITES dstdomain "/etc/squid/working-hour-sites.acl"

http_access allow WORKING_HOUR_SITES WORKING_HOUR_TIME

http_access deny !HTTPS_PORT
http_access deny CONNECT !HTTPS_PORT

http_access allow !WORKING_HOUR_TIME
http_access deny all

visible_hostname Berlint
EOS

    cat << EOS > /etc/squid/acl-time.conf
acl WORKING_HOUR_TIME time MTWHF 08:00-16:59
acl WEEKEND_TIME time SA 00:00-23:59
EOS

    cat << EOS > /etc/squid/working-hour-sites.acl
loid-work.com
franky-work.com
EOS

    cat << EOS > /etc/squid/acl-bandwidth.conf
delay_pools 1
delay_class 1 1
delay_access 1 allow WEEKEND_TIME
delay_parameters 1 16000/16000
EOS

    cat << EOS > /etc/squid/acl-port.conf
acl HTTPS_PORT port 443
acl CONNECT method CONNECT
EOS

    service squid restart

elif [[ $(hostname) = "Westalis" ]]; then
    apt update
    apt install \
    isc-dhcp-server -y

    cat << EOS > /etc/default/isc-dhcp-server
INTERFACES="eth0"
EOS
 
    cat << EOS > /etc/dhcp/dhcpd.conf
ddns-update-style none;
 
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;
 
default-lease-time 600;
max-lease-time 7200;
    
log-facility local7;

subnet 192.214.2.0 netmask 255.255.255.0 {}

subnet 192.214.1.0 netmask 255.255.255.0 {
    range 192.214.1.50 192.214.1.88;
    range 192.214.1.120 192.214.1.155;
    option routers 192.214.1.1;
    option broadcast-address 192.214.1.255;
    option domain-name-servers 192.214.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}
 
subnet 192.214.3.0 netmask 255.255.255.0 {
    range 192.214.3.10 192.214.3.30;
    range 192.214.3.60 192.214.3.85;
    option routers 192.214.3.1;
    option broadcast-address 192.214.1.255;
    option domain-name-servers 192.214.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}

host Eden {
    hardware ethernet 46:37:0c:a6:58:22;
    fixed-address 192.214.3.13;
}

EOS
 
    service isc-dhcp-server restart
    service isc-dhcp-server status

elif [[ $(hostname) = "Eden" ]]; then
    apt update
    apt install \
    lynx \
    speedtest-cli -y
elif [[ $(hostname) = "NewstonCastle" ]]; then
    echo "NewstonCastle"
elif [[ $(hostname) = "KemonoPark" ]]; then
    echo "KemonoPark"
fi