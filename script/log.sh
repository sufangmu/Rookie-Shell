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

#!/bin/bash

# Copyright Huawei Technologies Co., Ltd. 2017-2019. All rights reserved.
# Des: Print log on terminal and log file

set -e

#debug:0; info:1; warn:2; error:3
LOG_LEVEL=0 

log()
{
	local msg_cont=""
	local type=""

	type="$1"
	msg_cont="$2"
	date_time=$(date +'%F %H:%M:%S')

	log_format="${date_time} ${type} funcname: ${FUNCNAME[@]/log/} [line:$(caller 0 | awk '{print$1}')] ${msg_cont}"
	{
	case "${type}" in  
		debug)
			[[ "${LOG_LEVEL}" -le 0 ]] && echo -e "${log_format}" ;;
		info)
			[[ "${LOG_LEVEL}" -le 1 ]] && echo -e "${log_format}" ;;
		warn)
			[[ "${LOG_LEVEL}" -le 2 ]] && echo -e "${log_format}" ;;
		error)
			[[ "${LOG_LEVEL}" -le 3 ]] && echo -e "${log_format}" ;;
	esac
	} | tee -a "${NSTACK_BUILD_LOG_PATH}/build.log"
}
