#!/usr/bin/env bash

#######################
# MAIN script body
#######################

#. /hive/custom/$CUSTOM_MINER/h-manifest.conf
#local LOG_NAME="$CUSTOM_LOG_BASENAME.log"

stats_raw=`curl --connect-timeout 2 --max-time $API_TIMEOUT --silent --noproxy '*' http://127.0.0.1:8550/api/v1/stats`
if [[ $? -ne 0 || -z $stats_raw ]]; then
	echo -e "${YELLOW}Failed to read $miner from localhost:8550${NOCOLOR}"
else
	khs=`echo $stats_raw | jq -r '.total_hashrate_mean' | awk '{print $1/1000}'`
	local temp=`echo $stats_raw | jq -r '.devices[].temperature' | jq -cs '.'`
	local fan=`echo $stats_raw | jq -r '.devices[].fan_percent' | jq -cs '.'`
	local ac=$(jq '.found_solutions' <<< "$stats_raw")
	local rj=$(jq '.rejected_solutions' <<< "$stats_raw")
	local hs=`echo $stats_raw | jq -r '.devices[].hashrate_mean' | awk '{print $1/1000}' | jq -cs '.'`
	stats=$(jq --argjson temp "$temp" --argjson fan "$fan" --arg ac "$ac" --arg rj "$rj"  --argjson hs "$hs" --arg algo "ethash"\
		'{hs: $hs, $temp, $fan, $algo, uptime: .uptime_secs, ar: [$ac, $rj]}' <<< "$stats_raw")
fi

	[[ -z $khs ]] && khs=0
	[[ -z $stats ]] && stats="null"

