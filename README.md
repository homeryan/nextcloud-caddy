# Caddy Reverse Proxy + Nextcloud



1. Copy ```.env.template``` to ```.env``` and replace placeholders with your environment variables.
2. Run ```./initialize.sh``` to prepare Caddy and pull container images.
3. Run ```docker-compose up -d``` to start Nextcloud with Caddy.



Mariadb errors after update: [ERROR] Incorrect definition of table mysql.column_stats: expected column...

```bash
# docker exec -it [mariadb CONTAINER ID] /bin/sh
# mysql_upgrade --user=root --password=[MYSQL_ROOT_PASSWORD]
```





