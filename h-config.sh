#!/usr/bin/env bash
# This code is included in /hive/bin/custom function

	[[ -z $CUSTOM_USER_CONFIG ]] && echo -e "${YELLOW}Custom is empty${NOCOLOR}" && return 1


	#read config template
	conf=$CUSTOM_USER_CONFIG
	#replace values
	[[ -z $EWAL && -z $ZWAL && -z $DWAL ]] && echo -e "${RED}No WAL address is set${NOCOLOR}"
	[[ -n $EWAL ]] && conf=$(sed "s/%EWAL%/$EWAL/g" <<< "$conf")
	[[ -n $DWAL ]] && conf=$(sed "s/%DWAL%/$DWAL/g" <<< "$conf")
	[[ -n $ZWAL ]] && conf=$(sed "s/%ZWAL%/$ZWAL/g" <<< "$conf")
	[[ -n $EMAIL ]] && conf=$(sed "s/%EMAIL%/$EMAIL/g" <<< "$conf")
	[[ -n $WORKER_NAME ]] && conf=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< "$conf")
	#save config file
	echo $conf > $CUSTOM_CONFIG_FILENAME


