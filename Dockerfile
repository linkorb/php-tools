FROM docker.pkg.github.com/linkorb/php-docker-base/php-docker-base:latest

EXPOSE 80

COPY --chown=www-data:www-data . /app

WORKDIR /app

USER www-data

RUN COMPOSER_MEMORY_LIMIT=-1 /usr/bin/composer install
USER root

ENTRYPOINT ["apache2-foreground"]
