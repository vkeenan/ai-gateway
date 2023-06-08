#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Variable Declarations
source $DIR/.env

# Open the scratch org
sfdx project retrieve start --target-org $ORG_ALIAS