#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Variable Declarations
source $DIR/.env

sfdx data export tree  --json --output-dir ./data --query \
        "select id, name, model__c, order__c, \
    parameters__c, UsedCount__c, \
    tags__c, prompt__c, system__c \
    from Prompt__c" 