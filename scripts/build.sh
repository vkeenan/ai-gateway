#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Variable Declarations
source $DIR/.env
# Create a new scratch org 
echo "Creating scratch org...stand by..."
sf org create scratch -f $CONFIG_FILE -a $ORG_ALIAS --target-dev-hub $DEV_HUB_ALIAS

# Push metadata to the scratch org
sf project deploy start --target-org $ORG_ALIAS
sf org assign permset --name AI_Gateway --target-org $ORG_ALIAS
# Import sample data
sfdx data import tree \
    -f ./data/Prompt__c.json \
    --target-org $ORG_ALIAS
# Open the scratch org
sf org open --url-only --target-org $ORG_ALIAS 
