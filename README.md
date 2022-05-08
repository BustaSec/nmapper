# nmapper

### Purpose
nmapper is a simple bash script that automates a top 1000 nmap script/version tcp portscan followed by a full nmap portscan on multiple hosts. First and foremost,
***this script's main purpose was to help me learn some basic bash scripting syntax and keywords***, but also to help automate some initial scanning and enumeration for OSCP exam.
There are many other tools that already exist to accomplish this, however, I find many of them to return an overwhelming amount of data (simple is better for this specific use case imo), and I personally preferred to perform
additional and more granular enumeration manually for my exam.

### Features
* Prompts user to confirm hosts they wish to scan
* Runs scans on the same host in series
* Notifies user when scans have completed and how many remain
* Saves output in an organized manner with a commonsense naming convention

### Usage
`sudo ./nmapper.sh 10.0.0.1 172.16.0.1 192.168.0.1`
