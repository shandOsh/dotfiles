:: maze default route pro vnitrni sit
route DELETE 0.0.0.0 IF 10.162.0.1
:: pridava routy pro vnitrni sit pres gateway do vnitrni site
route ADD 10.89.0.0 MASK 255.255.0.0 10.162.0.1
route ADD 10.149.0.0 MASK 255.255.0.0 10.162.0.1
route ADD 10.153.0.0 MASK 255.255.0.0 10.162.0.1
route ADD 10.162.0.0 MASK 255.255.0.0 10.162.0.1
route ADD 10.168.0.0 MASK 255.255.0.0 10.162.0.1
route ADD 172.24.0.0 MASK 255.248.0.0 10.162.0.1