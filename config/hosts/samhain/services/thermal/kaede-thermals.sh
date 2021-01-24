#!/usr/bin/env bash
################################################################################
# Written by Kaede Fox <kaede@boxedfox.org>

##########
# thermald can't handle hwmon* moving around, so we use symlinks to resolve
# dynamic paths to static paths.
THERMAL_PATH="/var/cache/kaede-thermals"

# CPU sensor paths.
CPU_SENSOR_CORE="/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon*/temp1_input"
#CPU_SENSOR_SOCKET="/sys/devices/platform/nct6775.656/hwmon/hwmon*/temp2_input"

# GPU control and sensor paths (using amdgpu).
GPU_CONTROL="/sys/class/drm/card0/device/"
GPU_SENSOR="/sys/class/drm/card0/device/hwmon/hwmon*/temp1_input"

# WARNING: MAKE ABSOLUTELY SURE THESE ARE THE PERFORMANCE STATES AND NOT THE
# ACTUAL CORE/MEM CLOCKS OR WE COULD DAMAGE THE HARDWARE.
GPUCTRL_CORECLK="${GPU_CONTROL}/pp_dpm_sclk"
GPUCTRL_MEMCLK="${GPU_CONTROL}/pp_dpm_mclk"

# How often to resolve paths (in seconds). Changes are extremely rare, but they
# can occur even while the system is booted.
INTERVAL='300'
# How often to update GPU power settings from thermald.
TIMESLICE='1'

# Formatter used to round floats to integers via printf.
float_to_int='%'\''.0f'

##########
script_name=`basename $0`

# Our simple path resolver subroutine, which uses ls to replace hwmon* with
# whichever hwmon is currently active.
sub_resolve_paths() {
	ln -s -f "`ls $CPU_SENSOR_CORE`" "./cpu_core_temp"
#	ln -s -f "`ls $CPU_SENSOR_SOCKET`" "./cpu_socket_temp"
	ln -s -f "`ls $GPU_SENSOR`" "./gpu_temp"
}

case "$1" in
	"start")
		echo "loaded ${script_name}"

		mkdir -p "$THERMAL_PATH" 2>/dev/null
		cd "$THERMAL_PATH"

		# Switch the video driver into manual control mode for
		# performance levels.
		echo "manual" >${GPU_CONTROL}/power_dpm_force_performance_level
		echo "enabled gpupower"

		# Immediately resolve paths at startup.
		sub_resolve_paths

		# Followed by starting thermald in case the paths didn't
		# exist, which would've made it fail to start.
		sleep .5s
		systemctl start thermald

		# thermald will create these files with the wrong permissions.
		rm "./gpu_power_core"; printf "%d\n" '-1'>./gpu_power_core
		rm "./gpu_power_mem"; printf "%d\n" '-1'>./gpu_power_mem

		# Enter service mode.
		slice_counter='0'
		while true; do
			# Execute a timeslice. Paths are updated every time the
			# counter wraps around.
			slice_counter=$((slice_counter + TIMESLICE))
			if [ "$slice_counter" -ge "$INTERVAL" ]; then
				#printf "DEBUG: *** Updating paths after %d seconds ***\n" "$slice_counter"
				slice_counter=$((slice_counter - INTERVAL))
			
				# Resolve paths.
				sub_resolve_paths
			fi

			# Read GPU thermal settings from thermald and apply
			# them to the driver via sysfs.
			#
			# The core and memory clock lists are highly specific
			# to the hardware, and need updating if the video card
			# is ever changed.
			#
			gpu_power_core="`cat ./gpu_power_core`"
			gpu_power_mem="`cat ./gpu_power_mem`"
			if [ -z "$gpu_power_core" ]; then gpu_power_core='-1'; fi
			if [ -z "$gpu_power_mem" ]; then gpu_power_mem='-1'; fi

			# Check if we need to update the core clock.
			if [ "$gpu_power_core" -ge '0' ]; then
				#printf "DEBUG: *** Updating GPU core clock ***\n"
				printf "%d\n" '-1'>./gpu_power_core
				printf "$gpu_power_core\n">./gpu_power_core_cached

				core_count_f="$(echo "$gpu_power_core" | awk '{ x=(($1/255.0)*(7-1))+1; printf("%f",x) }')"
				core_count="$(printf "$float_to_int" "$core_count_f")"
				if [ "$core_count" -lt '1' ]; then core_count='1'; fi
				if [ "$core_count" -gt '7' ]; then core_count='7'; fi

				gpu_list_core="1"
				for ((i=2; i<=core_count; i++)); do
					gpu_list_core="$gpu_list_core $i"; done

				echo "$gpu_list_core" >${GPUCTRL_CORECLK}

				#echo "dbg: gpu_power_core: $gpu_power_core"
				#echo "dbg: core_count_f: $core_count_f, core_count: $core_count"
				#echo "dbg: gpu_list_core: $gpu_list_core"
			fi

			# Check if we need to update the memory clock.
			if [ "$gpu_power_mem" -ge '0' ]; then
				#printf "DEBUG: *** Updating GPU memory clock ***\n"
				printf "%d\n" '-1'>./gpu_power_mem
				printf "$gpu_power_mem\n">./gpu_power_mem_cached

				mem_count_f="$(echo "$gpu_power_mem" | awk '{ x=(($1/255.0)*(3-1))+1; printf("%f",x) }')"
				mem_count="$(printf "$float_to_int" "$mem_count_f")"
				if [ "$mem_count" -lt '1' ]; then mem_count='1'; fi
				if [ "$mem_count" -gt '3' ]; then mem_count='3'; fi

				gpu_list_mem="1"
				for ((i=2; i<=mem_count; i++)); do
					gpu_list_mem="$gpu_list_mem $i"; done

				echo "$gpu_list_mem" >${GPUCTRL_MEMCLK}

				#echo "dbg: gpu_power_mem: $gpu_power_mem"
				#echo "dbg: mem_count_f: $mem_count_f, mem_count: $mem_count"
				#echo "dbg: gpu_list_mem: $gpu_list_mem"
			fi

			# Sleep until the next cycle.
			sleep "${TIMESLICE}s"
		done
		;;
	"stop")
		# Reset all performance level tunings.
		echo "1 2 3 4 5 6 7" >${GPUCTRL_CORECLK}
		echo "1 2 3" >${GPUCTRL_MEMCLK}
		# Switch the video driver into automatic control mode for
		# performance levels.
		echo "auto" >${GPU_CONTROL}/power_dpm_force_performance_level
		echo "disabled gpupower"

		sleep .5s
		echo "unloaded ${script_name}"
		;;
	*)
		echo "Usage: ${script_name} (start | stop)"
		exit 1
		;;
esac