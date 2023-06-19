#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Variable Declarations
source $DIR/.env

sfdx data export tree  --json --output-dir ./data \
    --target-org $ORG_ALIAS \
    --query \
        "select id, name, model__c, order__c, \
    parameters__c, UsedCount__c, \
    tags__c, prompt__c, system__c, title__c, maxtokens__c, \
    temperature__c \
    from Prompt__c" 