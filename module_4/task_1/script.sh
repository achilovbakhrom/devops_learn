# Usage: ./script.sh 100000

# Arguments:
# 1) Threshold - with number type, if disk space is below of the amount, show notification message! By default it is 1 Gb.

default_threshold=1048576
number_regex="[0-9]+"

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
reset='\033[0m'

process_mem_info() {
	while [ true ]; do
		local human_readable_space=$(df -h / | awk '$NF == "/" {print $4}')
		local current_space=$(df / | awk '$NF == "/" {print $4}')
		echo -e "Current disk space is:$green $human_readable_space$reset and threshold is:$reset$yellow $1 bytes$reset"
		if [ $1 -gt $current_space ]; then
			echo -e "$red Warning: available disk space is less than threshold!$reset"
		fi
		sleep 2
	done
}


if [[ "$#" -eq 1 && $1 =~ $number_regex ]]; then
	process_mem_info $1
elif [[ "$#" -eq 0 ]]; then
	process_mem_info $default_threshold
else
	echo "Illegal number of arguments or invalid type of the argument."
fi
