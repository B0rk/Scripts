# Scripts
Scripts to help make life a little easier.

##Update_Git_Repositories.sh
This script will change directory to the Tools folder in the users home directory and then create a list of directories using `ls -l` and then perform a for loop to change into each directory, echo out what directory it is attempting to update, perform a git reset, perform a git pull, and then back out to the Tools directory. If the directory contains git files, it will then update from those repositories.
