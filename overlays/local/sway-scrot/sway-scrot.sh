#!/bin/sh

## Requirements:
##  - `grim`: screenshot utility for wayland
##  - `slurp`: to select an area
##  - `$MSGER`: to read properties of current window
##  - `$COPIER`: clipboard utility
##  - `jq`: json utility to parse $MSGER output
##  - `notify-send`: to show notifications

getTargetDirectory() {
	echo "/home/kat/media/scrots"
}

if [ -n "$SWAYSOCK" ]; then
	SWAY=yes;
	MSGER=swaymsg;
	COPIER="wl-copy";
	COPIERIMG="wl-copy --type image/png";
else
	SWAY=no;
	MSGER=i3-msg;
	COPIER="xclip -sel c"
	COPIERIMG="xclip -sel c -t image/png"
fi

if [ "$1" = "--notify" ]; then
	NOTIFY=yes
	shift 1
else
	NOTIFY=no
fi

ACTION=${1:-usage}
SUBJECT=${2:-screen}
FILENAME="$(date -Ins).png"
FILE=${3:-$(getTargetDirectory)/$FILENAME}

TOKEN=$(bitw get secrets/xbackbone -f token)

if [ "$ACTION" != "save" ] && [ "$ACTION" != "copy" ] && [ "$ACTION" != "check" ] && [ "$ACTION" != "upload" ] && [ "$ACTION" != "copys" ]; then
	echo "Usage:"
	echo "  kat-scrot [--notify] (copy|save|upload|copys) [active|screen|output|area|window] [FILE]"
	echo "  kat-scrot check"
	echo "  kat-scrot usage"
	echo ""
	echo "Commands:"
	echo "  copy: Copy the screenshot data into the clipboard."
	echo "  upload: Uses SCP to transfer the screenshot to a remote server."
	echo "  copys: Copy the screenshot data into the clipboard and save it to a regular file."
	echo "  save: Save the screenshot to a regular file."
	echo "  check: Verify if required tools are installed and exit."
	echo "  usage: Show this message and exit."
	echo ""
	echo "Targets:"
	echo "  active: Currently active window."
	echo "  screen: All visible outputs."
	echo "  output: Currently active output."
	echo "  area: Manually select a region."
	echo "  window: Manually select a window."
	exit
fi

notify() {
	notify-send -t 3000 -a grimshot "$@"
}
notifyOk() {
	[ "$NOTIFY" = "no" ] && return

	TITLE=${2:-"Screenshot"}
	MESSAGE=${1:-"OK"}
	notify "$TITLE" "$MESSAGE"
}
notifyError() {
	if [ $NOTIFY = "yes" ]; then
		TITLE=${2:-"Screenshot"}
		MESSAGE=${1:-"Error taking screenshot with grim"}
		notify -u critical "$TITLE" "$MESSAGE"
	else
		echo $1
	fi
}

die() {
	MSG=${1:-Bye}
	notifyError "Error: $MSG"
	exit 2
}

check() {
	COMMAND=$1
	if command -v "$COMMAND" > /dev/null 2>&1; then
		RESULT="OK"
	else
		RESULT="NOT FOUND"
	fi
	echo "   $COMMAND: $RESULT"
}

takeScreenshot() {
	FILE=$1
	GEOM=$2
	OUTPUT=$3
	if [ "$SWAY" = "yes" ]; then
		if [ ! -z "$OUTPUT" ]; then
			grim -o "$OUTPUT" "$FILE" || die "Unable to invoke grim"
		elif [ -z "$GEOM" ]; then
				grim "$FILE" || die "Unable to invoke grim"
		else
			grim -g "$GEOM" "$FILE" || die "Unable to invoke grim"
		fi
	else
			if [ "$GEOM" = "maim-cur" ]; then
				maim -i $(xdotool getactivewindow) "$FILE"
			elif [ "$GEOM" = "maim-s" ]; then
				maim -s "$FILE"
			elif [ "$GEOM" = "maim-out" ]; then
				maim -g "$OUTPUT" "$FILE"
			elif [ "$GEOM" = "maim-screen" ]; then
				maim "$FILE"
			fi
	fi
}

if [ "$ACTION" = "check" ] ; then
	echo "Checking if required tools are installed. If something is missing, install it to your system and make it available in PATH..."
	check grim
	check slurp
	check $MSGER
	check $COPIER
	check jq
	check notify-send
	exit
elif [ "$SUBJECT" = "area" ] ; then
	GEOM=$(slurp -d)
	# Check if user exited slurp without selecting the area
	if [ -z "$GEOM" ]; then
		exit
	fi
	WHAT="Area"
elif [ "$SUBJECT" = "active" ] ; then
	if [ "$SWAY" = "yes" ]; then
	FOCUSED=$($MSGER -t get_tree | jq -r 'recurse(.nodes[]?, .floating_nodes[]?) | select(.focused)')
	GEOM=$(echo "$FOCUSED" | jq -r '.rect | "\(.x),\(.y) \(.width)x\(.height)"')
	APP_ID=$(echo "$FOCUSED" | jq -r '.app_id')
	WHAT="$APP_ID window"
	else
		GEOM="maim-cur"
	fi
elif [ "$SUBJECT" = "screen" ] ; then
	if [ "$SWAY" = "yes" ]; then
	GEOM=""
	WHAT="Screen"
	else
		GEOM="maim-screen";
	fi
elif [ "$SUBJECT" = "output" ] ; then
	if [ "$SWAY" = "yes" ]; then 
	GEOM=""
	OUTPUT=$($MSGER -t get_outputs | jq -r '.[] | select(.focused)' | jq -r '.name')
	WHAT="$OUTPUT"
	else
MONITORS=$(xrandr | grep -o '[0-9]*x[0-9]*[+-][0-9]*[+-][0-9]*')
# Get the location of the mouse
XMOUSE=$(xdotool getmouselocation | awk -F "[: ]" '{print $2}')
YMOUSE=$(xdotool getmouselocation | awk -F "[: ]" '{print $4}')

for mon in ${MONITORS}; do
  # Parse the geometry of the monitor
  MONW=$(echo ${mon} | awk -F "[x+]" '{print $1}')
  MONH=$(echo ${mon} | awk -F "[x+]" '{print $2}')
  MONX=$(echo ${mon} | awk -F "[x+]" '{print $3}')
  MONY=$(echo ${mon} | awk -F "[x+]" '{print $4}')
  # Use a simple collision check
  if (( ${XMOUSE} >= ${MONX} )); then
    if (( ${XMOUSE} <= ${MONX}+${MONW} )); then
      if (( ${YMOUSE} >= ${MONY} )); then
        if (( ${YMOUSE} <= ${MONY}+${MONH} )); then
          # We have found our monitor!
					GEOM="maim-out"
          OUTPUT="${MONW}x${MONH}+${MONX}+${MONY}"
          break
        fi
      fi
    fi
  fi
done
	fi
elif [ "$SUBJECT" = "window" ] ; then
	if [ "$SWAY" = "yes" ]; then
		GEOM=$($MSGER -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)
	else
		GEOM="maim-s"
	fi
	# Check if user exited slurp without selecting the area
	if [ -z "$GEOM" ]; then
		exit
	fi
	WHAT="Window"
else
	die "Unknown subject to take a screen shot from" "$SUBJECT"
fi

if [ "$ACTION" = "copy" ] ; then
	takeScreenshot - "$GEOM" "$OUTPUT" | $COPIERIMG || die "Clipboard error"
	echo $FILE
	notifyOk "$WHAT copied to buffer"
elif [ "$ACTION" = "copys" ]; then 
	if takeScreenshot "$FILE" "$GEOM" "$OUTPUT"; then
		TITLE="Screenshot of $SUBJECT"
		MESSAGE=$(basename "$FILE")
		notifyOk "$MESSAGE" "$TITLE"
		echo $FILE
		cat "$FILE" | $COPIER || die "Clipboard error"
	else
		notifyError "Error taking screenshot with grim"
	fi
elif [ "$ACTION" = "upload" ]; then
	if takeScreenshot "$FILE" "$GEOM" "$OUTPUT"; then
		RESPONSE="$(curl -s -F "token=$TOKEN" -F "upload=@\"$FILE\"" https://files.kittywit.ch/upload)";
		    if [[ "$(echo "${RESPONSE}" | jq -r '.message')" == "OK" ]]; then
			URL="$(echo "${RESPONSE}" | jq -r '.url')/raw";
			    echo "${URL}" | $COPIER;
			    echo "${URL}";
			    notify-send "Upload completed!" "${URL}";
			exit 0;
		    else
			MESSAGE="$(echo "${RESPONSE}" | jq -r '.message')";
			if [ $? -ne 0 ]; then
			    echo "Unexpected response:";
			    echo "${RESPONSE}";
			    exit 1;
			fi
			if [ "${DESKTOP_SESSION}" != "" ]; then
			    notify-send "Error!" "${MESSAGE}";
			else
			    echo "Error! ${MESSAGE}";
			fi
			exit 1;
		    fi
	else 
		notifyError "Error taking screenshot with grim"
	fi
else
	if takeScreenshot "$FILE" "$GEOM" "$OUTPUT"; then
		TITLE="Screenshot of $SUBJECT"
		MESSAGE=$(basename "$FILE")
		notifyOk "$MESSAGE" "$TITLE"
		echo $FILE
	else
		notifyError "Error taking screenshot with grim"
	fi
fi
