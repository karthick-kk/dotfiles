#!/bin/bash

pgrep -x gammastep > /dev/null && pkill gammastep || gammastep -O 4500 &
# pkill -RTMIN+10 i3blocks