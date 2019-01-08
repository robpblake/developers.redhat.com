# Used to see the demonstrator environment with data from the most recent backup of production.
#!/bin/sh
set -ex
rm -rf /drupal-workspace/drupal_$DEPLOYMENT_ID/*
if [ ! -d "/drupal-workspace/drupal_$DEPLOYMENT_ID/drupal/config/active" ]
then
    BACKUP_DATE=`date -u '+%Y-%m-%d-%H-%M-%S'`
    BACKUP_DIR="/drupal-backups/drupal_$DEPLOYMENT_ID-$BACKUP_DATE"
    mkdir -p "$BACKUP_DIR"
    cp "/docker-entrypoint-initdb.d/drupal-db.sql.gz" "$BACKUP_DIR/drupal-db.sql.gz"
    cd /var/www/drupal/web
    tar czf "$BACKUP_DIR/drupal-filesystem.tar.gz" config sites
    chgrp -R root "$BACKUP_DIR"
    chmod -R 775 "$BACKUP_DIR"
else
    echo "Seed of environment has already been completed"
fi