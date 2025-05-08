#!/bin/bash

# Get the current window title using xdotool
TITLE=$(xdotool getwindowfocus getwindowname)

# Store original length before any truncation
ORIGINAL_LENGTH=${#TITLE}

# Limit the length of the title if needed
MAX_LENGTH=70
if [ ${#TITLE} -gt $MAX_LENGTH ]; then
  TITLE="${TITLE:0:$MAX_LENGTH}..."
fi

# Dynamic padding calculation based on title length
TITLE_LENGTH=${#TITLE}

# Base padding - adjust these values to fine-tune
BASE_LEFT_PADDING=34
BASE_RIGHT_PADDING=33

# Apply length-based adjustment with more consistent logic
# Use the original length for padding calculation to maintain consistent centering
if [ $ORIGINAL_LENGTH -gt 30 ]; then
  # For longer titles
  LEFT_PADDING_SPACES=$((BASE_LEFT_PADDING - 2))
elif [ $ORIGINAL_LENGTH -lt 15 ]; then
  # For shorter titles like "Firefox"
  LEFT_PADDING_SPACES=$((BASE_LEFT_PADDING - 3))
else
  # For medium-length titles
  LEFT_PADDING_SPACES=$BASE_LEFT_PADDING
fi

# For titles that weren't truncated, add extra right padding to balance
if [ $ORIGINAL_LENGTH -le $MAX_LENGTH ]; then
  # Add extra right padding for short titles to balance the center alignment
  RIGHT_PADDING_SPACES=$((BASE_RIGHT_PADDING + (MAX_LENGTH - TITLE_LENGTH) / 2))
else
  RIGHT_PADDING_SPACES=$BASE_RIGHT_PADDING
fi

# Generate the actual padding spaces
LEFT_PADDING=$(printf '%*s' $LEFT_PADDING_SPACES '')
RIGHT_PADDING=$(printf '%*s' $RIGHT_PADDING_SPACES '')

# Output the centered title with padding
echo "<span>${LEFT_PADDING}${TITLE}${RIGHT_PADDING}</span>"
