#!/usr/bin/env bash

# ======================================================================================================================
#
# @author: Thabo Lebogang Matjuda
# @since: 2020-11-09
# @email: <a href="mailto:thabo@anylytical.co.za">Anylytical Technologies</a>
#         <a href="mailto:tl.matjuda@gmail.com">Personal GMail</a>
#
# ======================================================================================================================


# DIRECTORIES / CONFIGS / IMPORTS
# ======================================================================================================================
PROPERITES_FILE_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source $(dirname $PROPERITES_FILE_PATH)/utilz/logger-util.sh

PROPERITES_FILE_SCRIPT_NAME="properties-file.sh"

RESPONSE_TRUE=0
RESPONSE_FALSE=1



# FUNCTIONS & OPS
# ======================================================================================================================

# Checks if the specified file exists.
# Usage : fileExists /path/to/the/file/here.properties
function fileExists() {
    fileToValidate=$1
    if [ -f "$fileToValidate" ]; then
      return $RESPONSE_TRUE
    else
      return $RESPONSE_FALSE
    fi
}

# Used to trim some String values / Text
function trimText() {
    local trimmedText="$1"

    # Strip leading space.
    trimmedText="${trimmedText## }"

    # Strip trailing space.
    trimmedText="${trimmedText%% }"

    echo "$trimmedText"
}

# Used to extract the value of a specified key with the intention of reading from a ".properties" file.
# Usage : getProp this.property.key /from/this/file/here.properties
function getProp() {
    propFilePath=$2

    if ! fileExists $propFilePath ; then
        logError $PROPERITES_FILE_SCRIPT_NAME "The specified [ properties ] file path : $propFilePath does not exist."
        exit
    fi
                          
    propToRead=$1

    # While we read each file line
    while read -r lineItem;
    do

        # Skip the line that have been commented out, all lines that start with the [ # ]
        [[ "$lineItem" =~ ^#.*$ ]] && continue

        # Check if the current line that we are on, matches the start of the property we want to read.
        # If they starting of the strings match then we know this is the config we are looking for.
        # If it's what we are looking for then we cut the line string at the point of the [ = ] character.
        # After cutting the string into two parts, we take the second part which is the value we are looking for
        if [[ $lineItem == $propToRead* ]]; then
            configVal=$(echo $lineItem | cut -d'=' -f2)
            echo $(trimText $configVal)
        fi
    done < "$propFilePath"  # The file we are reading each line from

}

# Used to modify a ".properties" file.
# This function will add the key if it does not exist
# Takes 3 Arguments :
#     keyToAddOrModify  : The key that you want to modify the value for.
#     valueToSet        : The value you want to update to, for that key.
#     propFilePath      : Path of the file.
# Usage : setProp this.assumed.key "withThisNewValue' /inside/this/config/file.properties
function setProp() {
    keyToAddOrModify=$1
    valueToSet=$2
    propFilePath=$3

    # Check if the file is there first
    if ! fileExists $propFilePath ; then
        logError $PROPERITES_FILE_SCRIPT_NAME "The specified [ properties ] file path : $propFilePath does not exist."
        exit
    fi

    # Check if the property exists in the file first
    # Using Regex to ignore the lines that have been commented out.
    if ! grep -R "^[#]*\s*${keyToAddOrModify}=.*" $propFilePath > /dev/null; then
        logInfo $PROPERITES_FILE_SCRIPT_NAME "Property '${keyToAddOrModify}' not found, so we are adding it in."
        echo "$keyToAddOrModify = $valueToSet" >> $propFilePath
    else
    # Handling a case where we have found out that the config exists so now it's a matter of editing its value
        logInfo $PROPERITES_FILE_SCRIPT_NAME "Updating the property '${keyToAddOrModify}' in the file."
        sed -ir "s/^[#]*\s*${keyToAddOrModify}=.*/$keyToAddOrModify=$valueToSet/" $propFilePath
    fi
}
