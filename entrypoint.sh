#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /rrails/tmp/pids/server.pid

exec "$@"
