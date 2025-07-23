#!/bin/bash

CYAN='\033[0;36m' # Cyan Blue
MAG='\033[0;35m'  # Magenta Pink
NC='\033[0m'      # No Color

default_pyversion=3

> dnf-available.txt
> pip-available.txt

# Read the file line by line
while IFS= read -r entry; do
    package="python${default_pyversion}-${entry}"
    echo -e "${CYAN}-------------------------------------------${NC}"
    echo -e "${CYAN}--- Searching for: ${package} ---${NC}"
    # dnf search ${package}
    dnf_search=$(dnf search ${package} -q)
    if [ -n "$dnf_search" ]; then
        echo -e "${MAG}${package}${NC} available in dnf!"
        echo ${package} >> dnf-available.txt
        echo "--- Installing: ${package} ---"
        dnf install -y ${package}
    else
        echo ${entry} >> pip-available.txt
    fi
done < "$1"

echo -e "\n${MAG} Installing packages available through pip :)${NC}"
pip${default_pyversion} install -r pip-available.txt
