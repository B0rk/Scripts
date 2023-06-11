# Scripts
Scripts to help make life a little easier.

## Update_Git_Repositories.sh
This script will change directory to the Tools folder in the users home directory and then create a list of directories using `ls -l` and then perform a for loop to change into each directory, echo out what directory it is attempting to update, perform a git reset, perform a git pull, and then back out to the Tools directory. If the directory contains git files, it will then update from those repositories.

## Auto-Relay.sh
This script generates a list of SMB relay-able hosts and proceeds to set up a socks proxy to relay to them. It will automatically perform dependency checks for Terminator, CrackMapExec, and Impacket-Scripts to see if the requirements are fulfilled before proceeding to execute. Also, enjoy the Rick and Morty flavor text. I had a lot of fun writing this and figuring out how to get everything to work properly.