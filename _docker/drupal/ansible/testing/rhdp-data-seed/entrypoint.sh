# Used to see the demonstrator environment with data from the most recent backup of production.
#!/bin/sh
mkdir -p "/drupal-workspace/drupal_$DEPLOYMENT_ID/drupal/config/active" "/drupal-workspace/drupal_$DEPLOYMENT_ID/seed/db"
cp "/docker-entrypoint-initdb.d/drupal-db.sql.gz" "/drupal-workspace/drupal_$DEPLOYMENT_ID/seed/db/drupal-db-sql.gz"
cp -r /var/www/drupal/web/config/active/* "/drupal-workspace/drupal_$DEPLOYMENT_ID/drupal/config/active"
cp -r "/var/www/drupal/web/sites/default/files" "/drupal-workspace/drupal_$DEPLOYMENT_ID/drupal"
chgrp -R root "/drupal-workspace/drupal_$DEPLOYMENT_ID"
chmod -R 775 "/drupal-workspace/drupal_$DEPLOYMENT_ID"