#!/bin/bash

# prints
export COLOR_RED='\e[1;31m'
export COLOR_GREEN='\e[1;32m'
export COLOR_RESET='\e[0m'

############## context ############## 

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
