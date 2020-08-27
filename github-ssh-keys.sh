#!/bin/bash

if [[ $# -eq 1 ]]; then
    echo "Getting ssh keys from github for user $1"
    # api_response=$(curl -s https://api.github.com/users/$1/keys)

    api_response=`cat json.json`

    readarray -t array < <(sed -n "/{/,/}/{s/[^:]*:[[:blank:]]*//p}" <<<$api_response)

    for i in "${!array[@]}"; do
        if [[ $((i % 2)) != 0 ]]; then
            echo "${array[i]} $1@github/${array[i - 1]} #github-key-importer" >>~/.ssh/authorized_keys
        fi
    done

    sed -i -E 's/"|,//g' ~/.ssh/authorized_keys
fi
