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
LOGGER_SCRIPT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
ZSH_SCRIPT_PATH=${0:a:h}

# CONFIGS
ERROR_TAG="[ERROR]"
INFO_TAG="[INFO]"
LINE_SPACE_TAG="[LINE]"
# ======================================================================================================================

# Get's the current date and time for logging purposes.
function getCurrentDateTime() {
    echo $(date +"%Y-%m-%d %T")
}

# Mimics a INFO Logging pattern.
# Taking in the ScriptName and Message to log.
# Usage = logInfo NameOfScript "Message I want to print out"
function logInfo() {
    scriptName=$1
    messageToLog=$2
    echo "$INFO_TAG `getCurrentDateTime` [$scriptName] : $messageToLog"
}

# Mimics a ERROR Logging pattern.
# Taking in the ScriptName and Message to log.
# Usage = logInfo NameOfScript "Message I want to print out
function logError() {
    scriptName=$1
    messageToLog=$2
    echo "$ERROR_TAG `getCurrentDateTime` [$scriptName] : $messageToLog"
}

function logLine() {
    echo "=============================================================================================================================================================================================="
}

# Just prints out a blank line space.
# Taking in the ScriptName and Message to log.
# Usage = logInfo NameOfScript
function logWhiteSpace() {
    scriptName=$1
    echo "$LINE_SPACE_TAG `getCurrentDateTime` [$scriptName] : "
}
