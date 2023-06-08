#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Variable Declarations
source $DIR/.env
# Create a new scratch org 
echo "Creating scratch org...stand by..."
sfdx force:org:create -s -f $CONFIG_FILE -a $ORG_ALIAS --target-dev-hub $DEV_HUB_ALIAS

# Push metadata to the scratch org
sfdx project deploy start --target-org $ORG_ALIAS
sfdx force:user:permset:assign --permsetname PromptEngineering --targetusername $ORG_ALIAS
# Import sample data
sfdx data import tree \
    -f ./data/Prompt__c.json \
    --target-org $ORG_ALIAS
# Open the scratch org
sfdx org open --target-org $ORG_ALIAS 
