FROM robpblake/rhdp-base
USER root
CMD ["/var/www/drupal/run-httpd.sh"]
EXPOSE 8080
WORKDIR /var/www/drupal
RUN gem install asciidoctor

COPY apache/drupal.conf /etc/httpd/conf.d/drupal.conf

# Copy in database migration files
COPY drupal-filesystem/db-migrations /var/www/drupal/db-migrations
COPY drupal-filesystem/phinx.yml /var/www/drupal/phinx.yml

# Run composer to install Drupal and required dependencies
COPY drupal-filesystem/scripts/ScriptHandler.php /var/www/drupal/scripts/
COPY drupal-filesystem/composer.json drupal-filesystem/composer.lock /var/www/drupal/
RUN cd /var/www/drupal \
    && /usr/local/bin/composer install -n

# Copy in the custom things we create
COPY drupal-filesystem/web/sites/default /var/www/drupal/web/sites/default
COPY drupal-filesystem/web/modules/custom /var/www/drupal/web/modules/custom
COPY drupal-filesystem/web/themes/custom /var/www/drupal/web/themes/custom

# Copy in the Drupal configuration
COPY drupal-filesystem/web/config/sync /var/www/drupal/web/config/sync

# Copy in scripts for start-up
COPY drupal-filesystem/scripts/run-httpd.sh /var/www/drupal/run-httpd.sh
RUN chmod +x /var/www/drupal/run-httpd.sh

# Permissions here are required for us to run on Openshift
RUN chown -R root:0 /run/httpd \
    && chmod -R 770 /run/httpd

USER 1000
ENV PATH=$PATH:/var/www/drupal/vendor/bin