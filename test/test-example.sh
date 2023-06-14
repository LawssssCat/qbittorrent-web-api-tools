#!/bin/bash

# prints
COLOR_RED='\e[1;31m'
COLOR_GREEN='\e[1;32m'
COLOR_RESET='\e[0m'

############## context ############## 
test_env_file="./set-env.sh" ; [ -f "$test_env_file" ] && source "$test_env_file"
cd ../example

example_index=0
example_exception=0
example_list="$(ls -1 | grep -v "set-env.sh")"
for example_name in $example_list; do
    echo -n "EXAMPLE_${example_index}: $example_name ... "
    bash ${example_name} 1>/dev/null
    if [ $? -ne 0 ]; then
        ((example_exception++))
        echo -e "${COLOR_RED}FAIL${COLOR_RESET}"
    else
        echo -e "${COLOR_GREEN}SUCCESS${COLOR_RESET}"
    fi
    ((example_index++))
done

if [ $example_exception -gt 0 ]; then
    echo 
    echo -e "${COLOR_RED}EXCEPTION: ${example_exception}${COLOR_RESET}" >&2
    exit 1
else
    exit 0
fi
