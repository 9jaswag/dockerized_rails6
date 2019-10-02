#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# bundle gems
bundle install -j "$(getconf _NPROCESSORS_ONLN)" --retry 5

# precompile assets
bin/rake assets:precompile


# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"