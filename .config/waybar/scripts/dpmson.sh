#!/bin/sh
hyprctl dispatch dpms on HDMI-A-2
killall -SIGUSR2 waybar