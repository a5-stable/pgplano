#!/bin/bash

set -e

echo "Starting PostgreSQL container..."
docker compose up -d

echo "Waiting for PostgreSQL to be ready..."
until docker exec pgplano-postgres pg_isready -U postgres > /dev/null 2>&1; do
    sleep 1
done

echo "Running seed.sql..."
docker exec -i pgplano-postgres psql -U postgres -d pgplano_development < "$(dirname "$0")/seed.sql"

echo "Done! Database is ready."
