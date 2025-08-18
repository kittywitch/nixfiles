#!/usr/bin/env bash
adb reverse tcp:9757 tcp:9757
adb shell am start -a android.intent.action.VIEW -d "wivrn+tcp://localhost" org.meumeu.wivrn
