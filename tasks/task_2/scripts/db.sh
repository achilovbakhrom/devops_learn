#!/bin/bash

# 1. add method
# 2. help
# 3. backup
# 4. restore
# 5. find
# 6. list/list --inverse

RED="\033[0;31m"
GREEN="\033[0;32m"
RESET="\033[0m"
FILENAME="../data/users.db"
BOLD="\033[1m"

contains_only_letters() {
	case $1 in
		*[![:alpha:]]*|"")
			return 1
			;;
		*)
			return 0
			;;
	esac
}

help_fn() {
	echo -e "This script is used for users database. It keeps usrename and role pairs in data/users.db file.
	COMMANDS: \n
	1) $BOLD ./db.sh add$RESET - requires to input username and role, after creates username, role recored in the db.
	2) $BOLD ./db.sh or ./db.sh help$RESET - description for the script.
	3) $BOLD ./db.sh find$RESET - requires in prompt to type searching username, in result you get username and role pair if it is in the db.
	4) $BOLD ./db.sh list$RESET - shows all users in the db.
		$BOLD--reversed$RESET - list will be shown in reversed order
	5) $BOLD ./db.sh backup$RESET - creates a backup file in data folder
	6) $BOLD ./db.sh restore$RESET - restores the latest backup file if in data folder any, in other case will be shown an error."
}

add_fn() {
	while true; do
		echo "Enter username(It should contain only latin letters):"
		read username
		contains_only_letters $username
		if [[ $? -eq 0 ]]; then break; fi
	done
	while true; do
		echo "Enter role for the $username(It should contain only lattin letters):"
		read role
		contains_only_letters $role
		if [[ $? -eq 0 ]]; then break; fi
	done
	echo "username $username and role $role"
	local found=false
	while read -r line; do
		if [[ $line = "$username, $role" ]]; then
			found=true
			break
		fi
	done < $FILENAME	
	if $found; then
		echo -e "$RED Such username and role pair is already exists$RESET"
	else
		echo "$username, $role" >> $FILENAME
		echo -e "$GREEN Successfully saved!$RESET"
	fi
}

backup_fn() {
	$(cp $FILENAME ../data/$(date +%F)-users.db.backup)
}

restore_fn() {
	if [[ ! -d ../data ]]; then
		echo "There is no data directory"
	else
		files=$(ls ../data/*.backup)
		newest_backup=$(printf '%s\n' $files | sort -rn | head -n1)
		echo $files
		echo $newest_backup
		if [[ -z $newest_backup ]]; then
			echo -e "$RED Backup file is not found!$RESET"
		else
			$(rm -rf ../data/users.db)
			$(cp $newest_backup ../data/users.db)
			echo -e "$GREEN Backup is performed successfully$RESET"
		fi
	fi
}

find_fn() {
	while true; do
    echo "Enter searching username(It should contain only latin letters):"
    read searching_username
    contains_only_letters $searching_username
    if [[ $? -eq 0 ]]; then break; fi
  done
	local index=1
	while read -r line; do
		if [[ "$line" =~ ^$searching_username,* ]]; then
			echo "$index. $line"
			((index++))
		fi
	done < $FILENAME

	if [ $index -eq 1 ]; then
		echo "Such user doesn't exist in users.db"
	fi
}

list_fn() {
	local array=()
	local j=1
	while read -r line; do
		array+=("$j. $line")
		((j++))
	done < $FILENAME
	if [[ $2 = "--reversed" ]]; then
		local i=$(( ${#array[@]} -1 ))
		while [ $i -ge 0 ]; do
			printf "%s\n" "${array[$i]}"
			((i--))
		done
	else
		local length=$(( ${#array[@]} -1 ))
		local i=0
    while [ $i -le $length ]; do
      printf "%s\n" "${array[$i]}"
      ((i++))
    done
	fi
}

if [[ ! -f ../data/users.db ]]; then
	if [[ ! -d ../data ]]; then
		$(mkdir ../data)
	fi
	$(touch ../data/users.db)
fi

case $1 in
	add)
		add_fn
		;;
	backup)
		backup_fn
		;;
	restore)
		restore_fn
		;;
	find)
		find_fn
		;;
	list)
		list_fn $@
		;;
	""|help)
		help_fn
		;;
	*)
		echo "${RED}The script doesn't support suck operation: $1${RESET}"
		;;
esac

