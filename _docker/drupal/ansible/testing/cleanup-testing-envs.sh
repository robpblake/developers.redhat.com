#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR/backup-env && docker-compose down -v
cd $DIR/bootstrap-env && docker-compose down -v
cd $DIR/cleanup-env && docker-compose down -v
