#!/usr/bin/env bash

# Get the current directory from the argument and replace $HOME with ~
dir="${1/#$HOME/'~'}"

# Get the maximum length from the argument or default to 30
max_length=${2:-30}

# Check if the directory length exceeds the maximum length
if [ ${#dir} -gt $max_length ]; then
  # Split the directory path by '/' and store the parts in an array
  IFS='/' read -ra ADDR <<< "$dir"

  # Get the length of the array
  length=${#ADDR[@]}

  # Determine the starting index for the last 3 parts
  start=$((length - 3))

  # Create the truncated directory path
  truncated=""
  for (( i=$start; i<$length; i++ )); do
    truncated="${truncated}/${ADDR[$i]}"
  done

  # Add '...' in front of the truncated path
  truncated="...${truncated}"

  # Handle the case where the truncated path is root "/"
  if [ "$truncated" == ".../" ]; then
    truncated="/"
  fi

  # Print the truncated directory path
  echo $truncated
else
  # Print the original directory path if it's within the length limit
  echo $dir
fi

