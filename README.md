# rt_iptables
"warning.rt.ru/?i"  
iptables -t mangle -I PREROUTING -p tcp --sport 80 -m u32 --u32 "0x60=0x7761726e&&0x64=0x696e672e&&0x68=0x72742e72&&0x6c=0x752f3f69" -j DROP
