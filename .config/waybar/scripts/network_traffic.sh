#!/bin/bash

# Determine active interface
IFACE=$(nmcli -t -f DEVICE connection show --active | head -n1)
if [ -z "$IFACE" ]; then
    # echo "<span font_size=\"large\">❌</span> NO CONNECTION"
    exit 0
fi

# Function to get RX/TX bytes
get_bytes() {
    rx_bytes=$(cat /sys/class/net/"$IFACE"/statistics/rx_bytes)
    tx_bytes=$(cat /sys/class/net/"$IFACE"/statistics/tx_bytes)
    echo "$rx_bytes $tx_bytes"
}

# Get initial values
initial_values=$(get_bytes)
initial_rx=$(echo "$initial_values" | cut -d' ' -f1)
initial_tx=$(echo "$initial_values" | cut -d' ' -f2)

# Wait for the specified interval
sleep 0.5

# Get values after the interval
final_values=$(get_bytes)
final_rx=$(echo "$final_values" | cut -d' ' -f1)
final_tx=$(echo "$final_values" | cut -d' ' -f2)

# Calculate speeds (bytes per second)
rx_speed=$((($final_rx - $initial_rx) * 2))  # Multiply by 2 because interval is 0.5
tx_speed=$((($final_tx - $initial_tx) * 2))

# Convert to KB/s
download=$(echo "scale=1; $rx_speed / 1024" | bc)
upload=$(echo "scale=1; $tx_speed / 1024" | bc)

# Convert to numeric values for comparison
down_val=$(echo "$download" | awk '{print int($1)}')
up_val=$(echo "$upload" | awk '{print int($1)}')

# Choose icons based on activity level
if [ "$down_val" -eq 0 ]; then
    down_icon="▁"
elif [ "$down_val" -lt 50 ]; then
    down_icon="▂"
elif [ "$down_val" -lt 200 ]; then
    down_icon="▃"
elif [ "$down_val" -lt 500 ]; then
    down_icon="▄"
elif [ "$down_val" -lt 1000 ]; then
    down_icon="▅"
else
    down_icon="▆"
fi

if [ "$up_val" -eq 0 ]; then
    up_icon="▁"
elif [ "$up_val" -lt 50 ]; then
    up_icon="▂"
elif [ "$up_val" -lt 200 ]; then
    up_icon="▃"
elif [ "$up_val" -lt 500 ]; then
    up_icon="▄"
elif [ "$up_val" -lt 1000 ]; then
    up_icon="▅"
else
    up_icon="▆"
fi

# Determine connection type
# if nmcli -t -f TYPE connection show --active | grep -q "ethernet"; then
#     conn_type="<span font_size=\"large\">🖧</span>"
# else
#     conn_type="<span font_size=\"large\">📶</span>"
# fi

# Output with pango markup
# echo "$conn_type <span color='#00FF00'>↓$down_icon</span> <span color='#FF6600'>↑$up_icon</span> ${download}/${upload} KB/s"
echo "$conn_type <span color='#00FF00' size='small' rise='4096'>↓$down_icon</span> <span color='#FF6600' size='small' rise='4096'>↑$up_icon</span>"