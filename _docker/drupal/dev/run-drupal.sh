#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cd $DIR && docker-compose down -v
cd $DIR && rm -rf $DIR/drupal-workspace
cd $DIR && docker-compose build --pull
cd $DIR && mkcert localhost
cd $DIR && docker-compose run --rm seed_env
cd $DIR && docker-compose run --rm bootstrap_env
cd $DIR && docker-compose run --rm bootstrap_drupal
cd $DIR && chmod -R 777 ./drupal-workspace/drupal_1/drupal/sites/default/files
cd $DIR && docker-compose up -d drupal
cd $DIR && docker-compose logs -f drupal