#!/bin/sh

# https://gist.github.com/mihow/9c7f559807069a03e302605691f85572
if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
else
  echo "Can't find .env file. Please run cp .env.template .env and replace environment varibles in the copied file."
  exit 1
fi

echo "Your Nextcloud's FQDN is $DOMAIN_NAME"
echo "Persistent data directory for MariaDB is $BASE_DIR/db"
echo "Web root directory for Nextcloud in $BASE_DIR/nextcloud"
echo "Nextcloud stores all files from users in $BASE_DIR/nextcloud/data"

mkdir -p caddy/certs
echo $DOMAIN_NAME > ./caddy/Caddyfile
echo >> ./caddy/Caddyfile
echo "reverse_proxy backend:80" >> ./caddy/Caddyfile

mkdir -p php-ini
# This php.ini file will be mapped to nextcloud container's
# /usr/local/etc/php/conf.d/zzz-custom.ini
# https://github.com/nextcloud/docker/issues/1014#issuecomment-595887548
# zzz- ensures this additional .ini file will be parsed last
echo "max_execution_time = $PHP_MAX_EXECUTION_TIME" > ./php-ini/php.ini

echo
docker-compose pull
docker container prune -f > /dev/null 2>&1
docker volume prune -f > /dev/null 2>&1

echo
echo "Run docker-compose up -d to start Nextcloud."
echo "After creating an admin account, add\n  'overwriteprotocol' => 'https',"
echo "above\n  'dbname' => 'nextcloud', \nin $BASE_DIR/nextcloud/config/config.php file."

echo
echo "Run sudo ./create-docker-compose-service.sh to reate a systemd service that"
echo "autostarts & manages a docker-compose instance in the current directory."
echo