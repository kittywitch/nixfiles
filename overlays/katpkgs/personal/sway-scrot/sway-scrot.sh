#!/bin/sh

## Requirements:
##  - `grim`: screenshot utility for wayland
##  - `slurp`: to select an area
##  - `swaymsg`: to read properties of current window
##  - `wl-copy`: clipboard utility
##  - `jq`: json utility to parse swaymsg output
##  - `notify-send`: to show notifications

getTargetDirectory() {
	echo "/home/kat/media/scrots"
}

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

REMOTE_USER="kat"
REMOTE_SERVER="kittywit.ch"
REMOTE_PORT="62954"
REMOTE_PATH="/var/www/files/"
REMOTE_URL="https://files.kittywit.ch/"

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
	if [ ! -z "$OUTPUT" ]; then
		grim -o "$OUTPUT" "$FILE" || die "Unable to invoke grim"
	elif [ -z "$GEOM" ]; then
		grim "$FILE" || die "Unable to invoke grim"
	else
		grim -g "$GEOM" "$FILE" || die "Unable to invoke grim"
	fi
}

if [ "$ACTION" = "check" ] ; then
	echo "Checking if required tools are installed. If something is missing, install it to your system and make it available in PATH..."
	check grim
	check slurp
	check swaymsg
	check wl-copy
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
	FOCUSED=$(swaymsg -t get_tree | jq -r 'recurse(.nodes[]?, .floating_nodes[]?) | select(.focused)')
	GEOM=$(echo "$FOCUSED" | jq -r '.rect | "\(.x),\(.y) \(.width)x\(.height)"')
	APP_ID=$(echo "$FOCUSED" | jq -r '.app_id')
	WHAT="$APP_ID window"
elif [ "$SUBJECT" = "screen" ] ; then
	GEOM=""
	WHAT="Screen"
elif [ "$SUBJECT" = "output" ] ; then
	GEOM=""
	OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused)' | jq -r '.name')
	WHAT="$OUTPUT"
elif [ "$SUBJECT" = "window" ] ; then
	GEOM=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)
	# Check if user exited slurp without selecting the area
	if [ -z "$GEOM" ]; then
		exit
	fi
	WHAT="Window"
else
	die "Unknown subject to take a screen shot from" "$SUBJECT"
fi

if [ "$ACTION" = "copy" ] ; then
	takeScreenshot - "$GEOM" "$OUTPUT" | wl-copy --type image/png || die "Clipboard error"
	notifyOk "$WHAT copied to buffer"
elif [ "$ACTION" = "copys" ]; then 
	if takeScreenshot "$FILE" "$GEOM" "$OUTPUT"; then
		TITLE="Screenshot of $SUBJECT"
		MESSAGE=$(basename "$FILE")
		notifyOk "$MESSAGE" "$TITLE"
		echo $FILE
		cat "$FILE" | wl-copy --type image/png || die "Clipboard error"
	else
		notifyError "Error taking screenshot with grim"
	fi
elif [ "$ACTION" = "upload" ]; then 
	if takeScreenshot "$FILE" "$GEOM" "$OUTPUT"; then
		if scp -P $REMOTE_PORT $FILE $REMOTE_USER@$REMOTE_SERVER:$REMOTE_PATH$FILENAME; then
			echo -n $REMOTE_URL$FILENAME | wl-copy
			notifyOk "Uploaded: $REMOTE_URL$FILENAME"
		else
			notifyError "Error uploading screenshot"
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
