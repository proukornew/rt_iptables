#!/bin/bash
# rt dpi(ip+resolved ips from dns)
# FIXME
# opkg install libidn
# opkg install dig
# opkg install coreutils-sleep
# opkg install iconv
#
# -A PREROUTING -p tcp -m tcp --sport 80 -m string --string "http://95.167.13.50/?st" --algo bm --from 89 --to 90 -j DROP
function resolve() {
	# include @dns.server
	for i in `dig +short $1 a`; do ipset add blacklist $i &> /dev/null; done
};

ipset list blacklist &> /dev/null

if [ $? -ne 0 ]
then
	echo "create ipset"
	ipset create blacklist hash:ip hashsize 1024
	# 5&0ff=58 -- change to your spoof isp's ttl or delete it
	iptables -t mangle -I PREROUTING -p tcp --sport 80 -m set --match-set blacklist src -m u32 --u32 "0x60=0x39352e31&&0x64=0x36372e31" -j DROP
	iptables -t mangle -I PREROUTING -p tcp --sport 443 -m set --match-set blacklist src -m u32 --u32 "4=0x00000000&&5&0xff=58&&0x20=0x50140000" -j DROP
fi

echo "start"
rkn=`curl -s "https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv" | iconv -f cp1251 | tail -n+2 | idn -u`
ips=`echo "$rkn" | cut -d ";" -s -f1 | tr -s " | " "\n" | sort | uniq`
ipset flush blacklist
for i in $ips; do ipset add blacklist $i; done
echo "ips done"

domains=`echo "$rkn" | cut -d ";" -s -f2 | sort | uniq`

for i in $domains;
do
	resolve $i &
	sleep 0.08
done
wait $!
echo "done"
#for i in $merged; do ipset add blacklist $i; done

#iptables -t mangle -I PREROUTING 2 -p tcp --sport 80 -m u32 --u32 "0x60=0x39352e31&&0x64=0x36372e31" -j LOG
#beeline dpi
#iptables -t mangle -I PREROUTING 3 -p tcp --sport 80 -m u32 --u32 "0x5a=0x626c6163&&0x5e=0x6b686f6c" -j DROP
