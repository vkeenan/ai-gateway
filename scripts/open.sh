#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Variable Declarations
source $DIR/.env

# Open the scratch org
sf org open --url-only --target-org $ORG_ALIAS 
