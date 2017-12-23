#!/bin/sh

btc-listalladdresses() {
     allaccounts=$(btc listaccounts | grep -o '".*"' | sed 's/"//g')
     if [ $? -ne 0 ]; then
        exit 1;
     fi; 

     for x in '' $allaccounts; do
         echo Account "'$x'":;
         btc getaddressesbyaccount "$x"; 
     done;
}


btc-dumpallprivkeys() {
     {
        allaccounts=$(btc listaccounts | grep -o '".*"' | sed 's/"//g')
        if [ $? -ne 0 ]; then
           exit 1;
        fi; 

        alladdresses=$({ for x in '' $allaccounts; do btc getaddressesbyaccount "$x"; done; } | grep -o '".*"' | sed 's/"//g')

        for addr in $alladdresses; do
            privkey=$(btc dumpprivkey $addr);
            if [ $? -ne 0 ]; then
               exit 1;
            fi; 
            echo $addr $privkey;
        done;
     } | sort

}

