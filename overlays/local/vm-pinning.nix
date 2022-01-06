{ pkgs, writeShellScriptBin }:

writeShellScriptBin "win10-vm-pinning" ''
set -eu

CPUSET=/sys/fs/cgroup/cpuset
#CPUSET=/dev/cpuset

cpuset_move() {
	local FROM=$1
	local TO=$2
	for proc in $(cat $CPUSET/$FROM/tasks); do
		echo $proc > $CPUSET/$TO/tasks || true
	done 2> /dev/null
}

echo 1 > $CPUSET/cpuset.sched_load_balance

if [[ ! -d $CPUSET/qemu ]]; then
	mkdir $CPUSET/qemu
	echo 0 > $CPUSET/qemu/cpuset.sched_load_balance
fi

if [[ ! -d $CPUSET/system ]]; then
	mkdir $CPUSET/system
	echo 1 > $CPUSET/system/cpuset.sched_load_balance
fi

cpuset_move qemu .
cpuset_move system .

echo "" > $CPUSET/qemu/cpuset.cpus

if [[ $# -lt 1 ]]; then
	exit 0
fi

QEMU_PID=$1
shift

echo "0-1,6-7" > $CPUSET/system/cpuset.cpus
cat < $CPUSET/cpuset.mems > $CPUSET/system/cpuset.mems
cat < $CPUSET/cpuset.mems > $CPUSET/qemu/cpuset.mems

echo "2-5,8-11" > $CPUSET/qemu/cpuset.cpus
#echo "1-3,5-7" > $CPUSET/qemu/cpuset.cpus
#echo "0,1,2" > $CPUSET/qemu/cpuset.cpus

cpuset_move . system

echo 1 > $CPUSET/qemu/cpuset.cpu_exclusive

for task in /proc/$QEMU_PID/task/*; do
	TASKNAME=$(grep -F "Name:" $task/status | cut -d $'\t' -f2)
	TASK=$(basename $task)

	case $TASKNAME in
		worker | qemu-system-*)
			echo worker is $TASKNAME
			;;
		CPU*)
			regex="CPU ([0-9]*)/KVM"
			if [[ $TASKNAME =~ $regex ]]; then
				CPU_ID=''${BASH_REMATCH[1]}
				echo $TASK > $CPUSET/qemu/tasks
				CPU_PIN=$((CPU_ID / 2 + (CPU_ID % 2) * 6 + 2))
        #CPU_PIN=$((CPU_ID * 2))
				taskset -p --cpu-list $CPU_PIN $TASK
			else
				echo unknown CPU $TASKNAME
				exit 1
			fi
			;;
		*)
			echo unknown task $TASKNAME
			;;
	esac
  done
''
