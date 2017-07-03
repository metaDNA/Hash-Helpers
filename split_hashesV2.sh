#! /bin/bash

#This script removes machine accounts from specified hash file.

#check for supplied file argument, else print instructions
if [ -z "$1" ]; then
echo "[*] ERROR: No File Specified."
echo "[*] Usage: $0 <hashes.txt>"
exit 0
fi

let "machines=0"
let "u_count=0"
let "count = $(cat $1 | wc -l)"
let "cleartext = $(cat $1 | grep CLEARTEXT | wc -l)"
echo "[*] Parsing " $count " Accounts..."
for x in $(cat $1); do
    for h in $(echo $x | cut -d ":" -f1); do
    if [[ $h == *'$' ]] 
        then
            echo $x >> machine_accounts.txt
            ((machines++))
        else
            echo $x >> user_accounts.tmp.txt
            ((u_count++))
        fi
    done
done
if [[ $cleartext -gt 0 ]]
    then
        echo "[!] CLEARTEXT CREDENTIALS FOUND IN FILE!"
        echo "[+] Writing to Seperate File..."
	$(cat $1 | grep CLEARTEXT >> cleartext.txt)
fi
echo "[*] Done."
echo "[*]" $machines " Machine Accounts Found (see machine_accounts.txt)"
echo "[*]" $u_count " User Accounts Found (see user_accounts.txt)"
echo "[*] Removing DES and AES hashes..."
cat user_accounts.tmp.txt | grep -v ':aes' | grep -v ':des' | grep -v ":dec" | grep -v ":rc4" | grep ":" > user_accounts.txt
# rm user_accounts.tmp.txt
echo "[*] Removed " $(( $u_count - $(cat user_accounts.txt | wc -l))) " DES and AES hashes."
echo "[*] Script Completed Successfully."
echo "[+] "$(cat user_accounts.txt | wc -l) " User Hashes Dumped." 
