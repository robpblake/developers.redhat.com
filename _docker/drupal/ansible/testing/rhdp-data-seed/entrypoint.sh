# Used to see the demonstrator environment with data from the most recent backup of production.
#!/bin/sh
mkdir -p "/drupal-workspace/drupal_$DEPLOYMENT_ID/drupal/config" "/drupal-workspace/drupal_$DEPLOYMENT_ID/seed/db"
cp "/docker-entrypoint-initdb.d/drupal-db.sql.gz" "/drupal-workspace/drupal_$DEPLOYMENT_ID/seed/db/drupal-db-sql.gz"
cp -r "/var/www/drupal/web/config/active" "/drupal-workspace/drupal_$DEPLOYMENT_ID/drupal/config"
cp -r "/var/www/drupal/web/sites/default/files" "/drupal-workspace/drupal_$DEPLOYMENT_ID/drupal"
chmod -R 775 "/drupal-workspace/drupal_$DEPLOYMENT_ID"