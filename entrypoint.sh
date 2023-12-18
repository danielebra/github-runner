#!/usr/bin/env bash
# Automatically de-register the runner when the container is terminated


function cleanup() {
  echo "Deregistering runner"
  ./config.sh remove --token $TOKEN
}

trap 'cleanup' SIGTERM

# Start the runner in the background
./run.sh &

# Save the runner's PID
runner_pid=$!

# Wait for the runner process to finish
wait $runner_pid
