#!/bin/bash

gpg --card-status &> /dev/null;
if [ $? -eq 0 ] || [ $? -eq 2 ]; then
	user=" $(gpg --card-status | grep 'Login data' | awk '{print $NF}')";
else
	user=" Disconnected"
fi

echo $user
