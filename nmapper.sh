#!/bin/bash

# Use nmapper.sh to perform a top 1000 nmap script/version tcp portscan, 
# followed by a full nmap tcp portscan. Accepts multiple hosts.

# EXAMPLE USAGE:
# sudo ./nmapper.sh 10.0.0.1 172.16.0.1 192.168.0.1

remainingFullScans=$#
remainingTop1000Scans=$#
ipAddressesTop1k=("$@")
declare -a ipAddressesFull
declare -a top1kPIDs
declare -a fullPIDs

cat << "EOF"
                                             
 _ __  _ __ ___   __ _ _ __  _ __   ___ _ __ 
| '_ \| '_ ` _ \ / _` | '_ \| '_ \ / _ \ '__|
| | | | | | | | | (_| | |_) | |_) |  __/ |   
|_| |_|_| |_| |_|\__,_| .__/| .__/ \___|_|   
                      |_|   |_|              
                                    
EOF

while :
do
    for i in $@
    do
        echo "$i"
    done
    read -p "Are you sure you want to scan these hosts? [Y/n]" input

    if [[ $input == [Nn] ]];
    then
        exit
    elif [[ $input == [Yy] || $input == "" ]]
    then
        break
    else
        continue
    fi
done

fullScan() {
	cd $1
	echo "[+] $1: Starting full scan..."
	nmap -Pn -T4 -p- -oN $1'_full.nmap' $1 > /dev/null 2>&1 &
	fullPIDs+=($!)
	cd ..
}


checkerFull() {
	ps -p $1 > /dev/null
	[ $? == 1 ] && echo "[!] $2: FULL SCAN FINISHED!!!"
}


checkerTop1k() {
	ps -p $1 > /dev/null
	[ $? == 1 ] && echo "[!] $2: TOP 1000 FINISHED!!!" && ipAddressesFull+=($2) && fullScan "$2" 
}


for i in $@
do
	mkdir $i
	cd $i
	echo "[+] $i: Starting top 1000 scan..."
	nmap -Pn -sCV --top-ports=1000 -oN $i'_top1k.nmap' $i > /dev/null 2>&1 &
	cd ..
	top1kPIDs+=($!)
done


while :
do
	sleep 2
	if (( $remainingTop1000Scans == 0 )) 
	then
		:
	else
		for j in "${!ipAddressesTop1k[@]}" 
		do
			if checkerTop1k "${top1kPIDs[$j]}" "${ipAddressesTop1k[$j]}"
			then
				unset top1kPIDs[$j] 
				unset ipAddressesTop1k[$j]
				let remainingTop1000Scans-=1
				echo "[*] Top 1000 scans remaining: $remainingTop1000Scans"
			fi
		done
	fi
	
	sleep 2
	if (( $remainingFullScans == 0 ))
	then
		break 2
	else
		for q in "${!ipAddressesFull[@]}"
		do
			if checkerFull "${fullPIDs[$q]}" "${ipAddressesFull[$q]}"
			then
				unset fullPIDs[$q]
				unset ipAddressesFull[$q]
				let remainingFullScans-=1
				echo "[*] Full scans remaining: $remainingFullScans"
			fi
		done
	fi

done

echo "***ALL SCANS COMPLETE***"
