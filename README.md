# rt_iptables
"warning.rt.ru/?i" -- строка для http 
5&0xff=120:123 -- ttl до dpi для https. Значение может периодически меняться, нужно найти диапазон от минимального до максимального (используется от 120-123)

iptables -t mangle -I PREROUTING -p tcp --sport 80 -m u32 --u32 "0x60=0x7761726e&&0x64=0x696e672e&&0x68=0x72742e72&&0x6c=0x752f3f69" -j DROP
iptables -t mangle -I PREROUTING -p tcp --sport 443 -m u32 --u32 "0x0=0x45000028&&0x4=0x00010000&&5&0xff=120:123&&0x20=0x5004fb90" -j DROP
