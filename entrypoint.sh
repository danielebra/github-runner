#!/usr/bin/env bash

# Automatically de-register the runner when the container is terminated
function cleanup() {
  echo "Deregistering runner"
  ./config.sh remove --token $TOKEN
}

# Deregister on stop
trap 'cleanup' SIGTERM
# Gracefully exit on interrupt
trap ':' SIGINT

# dockerd-rootless.sh > /dev/null 2>&1 &
# Start the runner in the background
./run.sh &

# Save the runner's PID
runner_pid=$!

# Wait for the runner process to finish
wait $runner_pid
