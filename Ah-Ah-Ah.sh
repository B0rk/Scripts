#!/bin/bash

#Font Things
RED="\e[91m"
ITALIC="\e[3m"
BOLD="\e[1m"
RESET="\e[0m"

#The Money Shot
i=0
while [ $i -lt 50 ]
do
    echo -e "${RED}${BOLD}${ITALIC}YOU DIDN'T SAY THE MAGIC WORD!${RESET}"
    sleep .1
    ((i++))
    if [[ "$i" == '45' ]]; then
    firefox --kiosk --private-window 'https://media4.giphy.com/media/3ohzdQ1IynzclJldUQ/giphy.gif?cid=ecf05e47n2jbulcr2ci18jd8dhgj3aistwvditd58w7fd9i9&ep=v1_gifs_search&rid=giphy.gif&ct=g' &> /dev/null&
    break
  fi
done
exit