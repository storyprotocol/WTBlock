#!/bin/bash

default_output_file="block_numbers_log.txt"

# Prompt the user to enter the log file name
read -p "Enter the log file name (default: $default_output_file): " output_file
output_file=${output_file:-$default_output_file}

# Ask the user for the number of requests and wait time, with defaults
read -p "Enter the number of times to send the request (default: 10): " num_requests
num_requests=${num_requests:-10}
read -p "Enter the number of seconds to wait between each call (default: 0 for no wait): " wait_time
wait_time=${wait_time:-0}

> "$output_file"

for (( i=1; i<=num_requests; i++ ))
do
  block_hex=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' https://testnet.storyrpc.io/ | jq -r '.result')
  block_hex="${block_hex#0x}"
  block_decimal=$((16#$block_hex))
  echo "Block $i: $block_decimal" >> "$output_file"
  echo "Attempt $i: Block number in decimal is $block_decimal"

  if [ "$wait_time" -gt 0 ]; then
    sleep "$wait_time"
  fi
done

echo "Block numbers logged to $output_file."