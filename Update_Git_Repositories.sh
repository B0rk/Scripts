#!/bin/bash

#Change to the Tools directory.
cd ~/Tools
#Perform for loop to change into each directory and run a forced git pull on all repository folders.
for n in $(ls -1)
do
	cd ~/Tools/$n
	if [ -d ".git" ]; then	
		echo "[+]Updating ${n}"
		git reset --hard &> /dev/null
		git pull
	fi
done
