#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Variable Declarations
source $DIR/.env
#
sfdx force:source:deploy --manifest ./manifest/package.xml --target-org $PACKAGE_ALIAS