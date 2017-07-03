#! /bin/bash

####
#This script recovers the duplicate accounts and performs post analysis on NTDS cracking
#2017 Hollowpo1nt
####

#check for supplied file argument, else print instructions
if [ -z "$2" ]; then
echo "[*] ERROR: Not Enough Arguments Specified."
echo "[*] Usage: $0 <org_hash_dump.txt> <cracked.txt>"
exit 0
fi

let "org_cracked=$(cat $2 | wc -l)"
let "total_hashes=$(cat $1 | grep ":" | wc -l)"

for hash in $(cat $2 | cut -d ":" -f2); do
	for num_of_hashes in $(cat $1 | grep $hash | wc -l); do 
		if [ $num_of_hashes -gt 1 ]
			then
			echo "$num_of_hashes $(cat $2 | grep $hash | cut -d ":" -f3)" >> stats_tmp.txt
			org_cracked=$((org_cracked + $num_of_hashes - 1))
		fi
	done
done

#Cleanup Results
echo "[+] Finished Mathing, Time to cleanup..."
echo "[+] Sorting results"
cat stats_tmp.txt | sort -nr > stats.txt
echo "[-] Deleting Temporary Files"
rm stats_tmp.txt
echo "[+] Generating New Stats"
echo "------Updated Cracking Stats------" >> stats.txt
echo "$org_cracked out of $total_hashes    Paste To Calc: $org_cracked/$total_hashes" >> stats.txt
echo "[+] Finished. Echoing stats.txt to terminal"
cat stats.txt

