#!/bin/bash

# Usage： log 'info' 'log message'
# 日志级别
# ERROR=1
# WORN=2
# INFO=3
# DEBUG=4
# 默认日志级别为3
LEVEL=3


log(){
    level=$(echo $1 | tr 'a-z' 'A-Z')
    message=$2
    DATE=$(date "+%Y-%m-%d %H:%M:%S")
    message="$DATE [${level}] ${BASH_SOURCE[1]}:${BASH_LINENO} func:${FUNCNAME[1]} ${message}"
    [ $LEVEL -ge 4 ] && [ $level = "DEBUG" ] &&  echo ${message}
    [ $LEVEL -ge 3 ] && [ $level = "INFO" ] &&  echo ${message}
    [ $LEVEL -ge 2 ] && [ $level = "WORN" ] &&  echo ${message}
    [ $LEVEL -ge 1 ] && [ $level = "ERROR" ]  &&  echo ${message}
}