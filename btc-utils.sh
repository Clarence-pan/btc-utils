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


hashes-calc() {
   bak="$1"
   if [ "$bak" == "" ]; then
       echo Usage: $0 "<backup-file>"  -- calculate mutile hashes.
       return 1;
   fi

   if ! [ -f $bak ]; then
       echo Error: $bak not exist.
       return 1;
   fi

   { for a in md5sum sha1sum  sha256sum  sha512sum; do echo $a:`$a $bak`; done } > $bak.hash
}

hashes-verify() {
   bak="$1"
   if [ "$bak" == "" ]; then
       echo Usage: $0 "<backup-file>"  -- calculate mutile hashes.
       return 1;
   fi

   if ! [ -f $bak ]; then
       echo Error: $bak not exist.
       return 1;
   fi

   { sum=$( for a in md5sum sha1sum  sha256sum  sha512sum; do echo $a:`$a $bak`; done ); sum2=`cat $bak.hash`; if [ "$sum" != "$sum2" ]; then echo Error. ; exit 1; else echo OK.; fi; }
}




