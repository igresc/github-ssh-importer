#!/bin/bash

# Test if 

if [[ -n "$1" ]]; then
    # Asks if the user inserted is correct
    read -p "Getting ssh keys from github for user $1 are you sure? [Y/n] " confirm
    if [[ $confirm == n ]]
    then
        echo "Exit"
        exit 0
    fi
    # api_response=$(curl -s https://api.github.com/users/$1/keys) # Get ssh keys for user from Github api

    api_response=`cat json.json` # ONLY for testing Github api max requests

    readarray -t array < <(sed -n "/{/,/}/{s/[^:]*:[[:blank:]]*//p}" <<<$api_response) # Convert json format into an string array

    # From the array get the key and id, formatted to the correct form and added to the authoriezed_keys file.
    for i in "${!array[@]}"; do
        if [[ $((i % 2)) != 0 ]]; then
            echo "${array[i]} $1@github/${array[i - 1]} #github-key-importer" >>~/.ssh/authorized_keys
        fi
    done

    sed -i -E 's/"|,//g' ~/.ssh/authorized_keys # Remove double quotes
else
    printf "illegal argument\n" >&2
    echo " 
Usage: 
    ./github-ssh-keys.sh username
    " >&2
fi
