# User Documentation — Inception

---

## What services does this stack provide?

This project runs three services inside Docker containers, all managed by Docker Compose:

| Service | Role | Technology |
|---|---|---|
| NGINX | The only entry point. Handles HTTPS and forwards requests to WordPress | NGINX + TLSv1.3 |
| WordPress | The website and admin panel | WordPress + php-fpm |
| MariaDB | The database that stores all WordPress content and users | MariaDB |

All traffic enters through NGINX on port 443 (HTTPS) only. No other ports are exposed to the outside.

---

## Start and stop the project

```bash
make help
```

| Command | Description |
|---|---|
| `make up` | Build and start the Docker Compose setup |
| `make start` | Start existing containers |
| `make stop` | Stop running containers |
| `make down` | Remove containers and networks |
| `make clean` | Remove images |
| `make fclear` | Remove all volumes, containers, and networks |
| `make re` | Clean up and restart from scratch |
| `make status` | Show container status |
| `make logs` | Show health logs for all containers |
| `make logs-mariadb` | Show MariaDB logs |
| `make logs-wordpress` | Show WordPress logs |
| `make logs-nginx` | Show Nginx logs |
| `make exec-mariadb` | Open a shell in the MariaDB container |
| `make exec-wordpress` | Open a shell in the WordPress container |
| `make exec-nginx` | Open a shell in the Nginx container |

---

## Access the website and admin panel

Before accessing the site, make sure your `/etc/hosts` file contains this line:

```
127.0.0.1   yanflous.42.fr
```

Replace `yanflous` with the project owner's 42 login.

**Website:**
```
https://yanflous.42.fr
```

**WordPress admin panel:**
```
https://yanflous.42.fr/wp-admin
```

> Your browser will show a certificate warning because the SSL certificate is self-signed. Click "Advanced" and proceed anyway.

---

## Locate and manage credentials

All credentials are managed through a single file:

```
srcs/.env
```

Create it before running the project using this template:

```dotenv
DOMAIN_NAME="yanflous.42.fr"

# MySQL
WP_DB_NAME="wordpress database name"
MYSQL_USER="user name"
MYSQL_PASSWORD="password"
MYSQL_ROOT_PASSWORD="root pass"

# WordPress User
WP_USER="wp user"
WP_USER_PASSWORD="password"
WP_USER_EMAIL="user@student.42.fr"

# WordPress Admin
WP_ADMIN_USER="admine user name"
WP_ADMIN_PASSWORD="admine password"
WP_ADMIN_EMAIL="admine@admin.42.fr"
```

| Variable | Description |
|---|---|
| `DOMAIN_NAME` | Your site domain — must match your 42 login as subject say |
| `MYSQL_USER` / `MYSQL_PASSWORD` | MariaDB regular user credentials |
| `MYSQL_ROOT_PASSWORD` | MariaDB root password |
| `WP_ADMIN_USER` / `WP_ADMIN_PASSWORD` | WordPress admin login (must not contain "admin") |
| `WP_USER` / `WP_USER_PASSWORD` | WordPress regular user login |

> `.env` It is listed in `.gitignore`.

---

## Check that services are running correctly

**See all running containers:**
```bash
docker compose -f srcs/docker-compose.yml ps
```

All three services (`nginx`, `wordpress`, `mariadb`) should show status `Up`.

**Check logs for a specific service:**
```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

**Check a container is reachable:**

-k = allow curl not block the connection for safety, because it's a self signed

```bash
curl -k https://yanflous.42.fr
```

You should see HTML from the WordPress homepage.

**Check the database is running:**
```bash
docker exec -it mariadb mariadb -u root -p
```
