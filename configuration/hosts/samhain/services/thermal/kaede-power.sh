#!/usr/bin/env bash
################################################################################
# Written by Kaede Fox <kaede@boxedfox.org>

##########
# Default governor, currently required to be "conservative".
METHOD=conservative

# Configuration parameters.
SCALE_UP=40
SCALE_DOWN=30
SCALE_STEP=1
SAMPLING_RATE=10000
SAMPLING_FACTOR=10
NO_NICE=1

##########
script_name=`basename $0`

case "$1" in
	"start")
		modprobe cpufreq_conservative
		modprobe cpufreq_ondemand

	# This also needs to be loaded, in case the service is stopped later
	# we can fall back to it.
		modprobe cpufreq_performance

	# The governor must be selected for its relevant configuration entries
	# to appear in sysfs.
		cpupower frequency-set -g $METHOD
		sleep .5s

		CONFIG=/sys/devices/system/cpu/cpufreq/$METHOD
		chmod $CONFIG 644
		echo $SCALE_UP > $CONFIG/up_threshold
		echo $SCALE_DOWN > $CONFIG/down_threshold
		echo $SCALE_STEP > $CONFIG/freq_step
		echo $SAMPLING_RATE > $CONFIG/sampling_rate
		echo $SAMPLING_FACTOR > $CONFIG/sampling_down_factor
		echo $NO_NICE > $CONFIG/ignore_nice_load
		sleep .5s

	# Force reload all configuration.
		cpupower frequency-set -g $METHOD
		echo "enabled cpupower"

		echo "loaded ${script_name}"
		;;
	"stop")
		cpupower frequency-set -g performance &&
			echo "disabled cpupower" &
			wait

		sleep .5s
		modprobe -r cpufreq_conservative
		modprobe -r cpufreq_ondemand

		echo "unloaded ${script_name}"
		;;
	*)
		echo "Usage: ${script_name} (start | stop)"
		exit 1
		;;
esac