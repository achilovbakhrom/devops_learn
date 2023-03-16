#!/bin/bash

JQ_COMMAND=jq
FILENAME=pipeline.json
FILEPATH=./$FILENAME

if ! command -v $JQ_COMMAND &> /dev/null
then
    echo "$JQ_COMMAND could not be found, first install it"
		echo "To install use command: sudo apt install $JQ_COMMAND"
    exit
else
    echo "$JQ_COMMAND is found, we can keep continue working."
fi

json_file=$1

if [ -z $json_file ]; then
    json_file=$FILE_NAME
fi
echo "JSON file is $json_file"

index=0
args=($@)
echo "args $args"
for i in $@; do
    case $i in
        --configuration) conf="${args[index+1]}";;
        --owner) owner="${args[index+1]}";;
        --branch) branch="${args[index+1]}";;
        --poll-for-source-changes) is_poll=${args[index+1]};;

    esac
    ((index++))
done

output_file=./output.json

jq 'del(.metadata)' "$json_file" > $output_file

version=$(jq '.pipeline.version' "$output_file")
((version++))
jq "(.pipeline.version = $version)" $output_file > tmp.$$.json && mv tmp.$$.json $output_file

if [ -z $branch ]; then
    branch = "main"
fi
echo "branch: $branch"

jq "(.pipeline.stages[0].actions[0].configuration.Branch = \"$branch\")" $output_file > tmp.$$.json && mv tmp.$$.json $output_file

if [ ! -z $owner ]; then
    jq "(.pipeline.stages[0].actions[0].configuration.Owner = \"$owner\")" $output_file > tmp.$$.json && mv tmp.$$.json $output_file
fi

echo "Script has finished the process!"




