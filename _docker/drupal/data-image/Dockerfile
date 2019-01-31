FROM alpine:3.4
MAINTAINER rblake@redhat.com

# Make the directory structure that will be exposed as volumes by this data container
RUN mkdir -p /var/www/drupal/web \
    /docker-entrypoint-initdb.d

# Copy the database dump and drupal files
COPY work/data-image/drupal-db.sql.gz /docker-entrypoint-initdb.d
ADD work/data-image/drupal-filesystem.tar.gz /var/www/drupal/web