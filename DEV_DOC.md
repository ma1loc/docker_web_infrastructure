# Developer Documentation — Inception

---

## Prerequisites

Before setting up the project, make sure the following are installed on your machine:

| Tool | Purpose | Check |
|---|---|---|
| Docker | Container engine | `docker --version` |
| Docker Compose | Multi-container orchestration | `docker compose version` |
| Make | Build automation | `make --version` |
| Git | Clone the repository | `git --version` |

The project must run inside a **Virtual Machine**. Do not run it directly on your host machine.

---

## Set up the environment from scratch

### 1. Clone the repository

```bash
git clone https://github.com/ma1loc/docker_web_infrastructure.git
cd docker_web_infrastructure
```

### 2. Create the `.env` file

The project will not build without this file. Create it at `srcs/.env`:

```bash
touch srcs/.env
```

Paste the following template and replace values with your own:

```dotenv
DOMAIN_NAME="yanflous.42.fr"

# MySQL
WP_DB_NAME="wordpress"
MYSQL_USER="yanflous"
MYSQL_PASSWORD="pass123"
MYSQL_ROOT_PASSWORD="root123"

# WordPress
WP_DB_USER="yanflous"
WP_DB_PASSWORD="pass123"
WP_DB_HOST="mariadb"

# WordPress User
WP_USER="yanflous_user"
WP_USER_EMAIL="user@student.42.fr"
WP_USER_PASSWORD="UserPass123!"

# WordPress Admin
WP_ADMIN_USER="yanflous_admin"
WP_ADMIN_PASSWORD="pass123!"
WP_ADMIN_EMAIL="yanflous@student.42.fr"
```

> `WP_ADMIN_USER` must not contain "admin" or "administrator" in any form — this is a hard requirement from the subject.

### 3. Configure the domain

Add the following line to `/etc/hosts` on your VM:

```bash
sudo sh -c 'echo "127.0.0.1 yanflous.42.fr" >> /etc/hosts'
```

Replace `yanflous` with your actual 42 login.

### 4. Create the data directories

The named volumes store data on the host at `/home/yanflous/data`. Create them manually before the first run:

```bash
mkdir -p /home/yanflous/data/wordpress
mkdir -p /home/yanflous/data/mariadb
```

Replace `yanflous` with your login.

---

## Project structure

```
.
├── Makefile
└── srcs/
    ├── .env                    ← credentials and config (never commit)
    ├── docker-compose.yml      ← orchestrates all services
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/           ← nginx.conf
        │   └── tools/          ← entrypoint scripts
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/           ← php-fpm config
        │   └── tools/          ← wp-config and setup scripts
        └── mariadb/
            ├── Dockerfile
            ├── conf/           ← mariadb config
            └── tools/          ← db init scripts
```

---

## Build and launch the project

### First run

```bash
make up
```

This single command:
- Reads `srcs/docker-compose.yml`
- Builds all three Docker images from their Dockerfiles
- Creates the Docker network `inception_net`
- Creates the two named volumes
- Starts all three containers in the correct order

### Verify everything started correctly

```bash
make status
```

All three services — `nginx`, `wordpress`, `mariadb` — must show status `Up`.

Then open a browser and visit:

```
https://yanflous.42.fr
```

Accept the self-signed certificate warning and you should see the WordPress site.

---

## Manage containers and volumes

### Full Makefile reference

```bash
make help
```

| Command | Description |
|---|---|
| `make up` | Build images and start all containers |
| `make start` | Start existing stopped containers |
| `make stop` | Stop running containers without removing them |
| `make down` | Remove containers and networks (volumes preserved) |
| `make clean` | Remove built images |
| `make fclear` | Remove everything — containers, networks, volumes, images |
| `make re` | Full clean and restart from scratch |
| `make status` | Show status of all containers |
| `make logs` | Show logs for all containers |
| `make logs-nginx` | Show NGINX logs |
| `make logs-wordpress` | Show WordPress logs |
| `make logs-mariadb` | Show MariaDB logs |
| `make exec-nginx` | Open a shell inside the NGINX container |
| `make exec-wordpress` | Open a shell inside the WordPress container |
| `make exec-mariadb` | Open a shell inside the MariaDB container |

### Useful raw Docker commands

**List all containers:**
```bash
docker ps -a
```

**List all volumes:**
```bash
docker volume ls
```

**Inspect a volume:**
```bash
docker volume inspect <volume_name>
```

**Enter a running container manually:**
```bash
docker exec -it <container_name> sh
```

**Connect to MariaDB directly:**
```bash
docker exec -it mariadb mariadb -u root -p
```
Enter `MYSQL_ROOT_PASSWORD` from your `.env` file.

**Remove all stopped containers:**
```bash
docker container prune
```

**Remove all unused volumes:**
```bash
docker volume prune
```

---

## Where data is stored and how it persists

The project uses two **named volumes** defined in `docker-compose.yml`. Both are configured to store data in a specific path on the host machine:

| Volume | Host path | Container path | Contains |
|---|---|---|---|
| `wordpress_data` | `/home/yanflous/data/wordpress` | `/var/www/html` | WordPress PHP files |
| `mariadb_data` | `/home/yanflous/data/mariadb` | `/var/lib/mysql` | Database files |

### How persistence works

- Both volumes are **named volumes** — Docker manages them and pre-populates them from the container image on first run if empty.
- Stopping or removing containers does **not** delete volume data.
- Only `make fclear` or `docker volume rm` will permanently delete the data.
- The data directories on the host survive container removal — you can inspect them directly:

```bash
ls /home/yanflous/data/wordpress
ls /home/yanflous/data/mariadb
```

### Why named volumes and not bind mounts

Bind mounts require the host path to exist and be managed manually. Named volumes let Docker handle initialization — on first run, Docker copies the WordPress files and MariaDB system tables from the image into the volume automatically. This prevents the database from crashing on startup due to missing system tables.

---

## Common issues

| Problem | Likely cause | Fix |
|---|---|---|
| Site not loading | `/etc/hosts` not configured | Add `127.0.0.1 yanflous.42.fr` to `/etc/hosts` |
| Containers not starting | `.env` file missing or wrong path | Create `srcs/.env` with the full template |
| Database errors on startup | Data directory missing | Run `mkdir -p /home/yanflous/data/mariadb` |
| Port 443 already in use | Another service using the port | Stop the conflicting service or reboot the VM |
| Certificate warning in browser | Self-signed SSL cert | Expected — click "Advanced" and proceed |
