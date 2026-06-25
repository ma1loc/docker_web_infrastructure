## This project was created as part of the 42 curriculum by [yanflous](https://github.com/ma1loc)

---

## Description

Inception is a system administration and DevOps-oriented project from **1337 School**. The goal is to build a complete web infrastructure using **Docker** and its ecosystem, following strict rules and best practices.

This project focuses on understanding how containers work together to form a reliable and scalable environment, rather than relying on pre-built images or shortcuts.

![Infrastructure Screenshot](https://github.com/user-attachments/assets/b2bf9830-a087-4f35-b3c8-a5948fa9dfcf)

---

## Getting Started

### Step 1 — Clone the Repository

If you have already cloned the repository, skip this step. Otherwise, open your terminal and run:

```bash
git clone https://github.com/ma1loc/docker_web_infrastructure.git && cd ./docker_web_infrastructure
```

### Step 2 — Build & Run

After cloning the project, all the files required for Inception are placed in the `srcs/` folder. Feel free to read through them — comments are included to help you understand each statement.

> [!IMPORTANT]
> Before building the containers, you must create a `.env` file at `srcs/.env`.
> Create the file and paste the following template, replacing the values with your own:

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

A `Makefile` is provided in the root folder to make execution straightforward. To see all available commands, run:

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

Your first command should be:

```bash
make up
```

This runs the Docker Compose configuration, creating images, network interfaces, volumes, environment variables, and everything needed to start the containers.

You can also use `make stop` to pause the containers and `make start` to resume them. When you're done, `make fclear` removes everything as if nothing ever happened.

---

### Step 3 — Visit the Website

Once your containers are running correctly, open your browser and visit:

[https://yanflous.42.fr](https://yanflous.42.fr)

---

## Resources

I built my own in-depth resource for this project — if you're interested, you can [check it out on Medium](https://medium.com/@ma1loc/docker-web-infrastructure-d5c58f8e3f71).

During the learning process, I also used AI assistance — especially for catching subtle errors (like missing `-y` flags when installing dependencies), and for debugging network communication between containers. AI is particularly strong at networking issues, and I learned a lot from those interactions.

---

## Project Overview

Below is a brief overview of the project. A much deeper breakdown is available in my Medium resource linked above.

### Why Docker Exists

Docker was created to make developers' lives easier. Working on an application across different environments causes a lot of problems — just because something works on your machine doesn't mean it works on someone else's. That's the core idea behind Docker: **synchronizing environments**.

Docker provides an environment that includes everything an application needs to run on any machine. You build the environment first, then ship the environment together with the application — that combined unit is a **container**.

---

## Architecture & Design Choices

The project is built according to the subject requirements. Each service runs in its own container, which is the standard Docker practice for proper isolation, synchronization, and security.

### Nginx

Nginx runs in its own isolated container with port `443` mapped to the host machine, allowing it to receive incoming HTTP/HTTPS requests. Communication between the Nginx container and the WordPress container happens over a bridge network.

### WordPress

WordPress serves website content. When Nginx receives a request, it fetches the response as a static file from WordPress. WordPress has a shared database with Nginx for serving static content, but for dynamic operations (logins, comments, etc.), WordPress communicates directly with MariaDB. All containers share a single Docker network, allowing them to reach each other by service name.

### MariaDB

MariaDB stores all user and admin account data. Every new registration is persisted in the MariaDB database, and it is also used for authentication. MariaDB has its own dedicated volume to ensure data is not shared or lost between restarts.

---

## Key Concepts

### Virtual Machines vs. Docker

**The old problem:** In the early days, a single server could only run one operating system (OS) and one application. Running multiple applications on the same server was impossible because of dependency conflicts.

**Example:**
- `APP_A` requires PHP 5.6
- `APP_B` requires PHP 8.2

On a single server without virtualization, only one PHP version can be installed at a time. Installing PHP 5.6 breaks `APP_B`; upgrading to PHP 8.2 breaks `APP_A`. Despite having enough hardware resources, the two apps cannot coexist.

**Virtual Machines (VMs)** solved this by introducing an abstraction layer between hardware and software, allowing a single physical server to run multiple isolated operating systems simultaneously. Each application gets its own OS, each OS can install its own dependencies — problem solved.

However, VMs introduced a new issue: **resource overhead**. Each VM requires a full OS installation — its own kernel, boot system, and OS license. This consumes a significant amount of disk space and memory, and VMs are slow to start.

**Docker** solved the VM overhead problem. Instead of giving each application a full operating system, Docker gives each app only what it needs — nothing more, nothing less. Containers share the host kernel, making them lightweight, fast to start, and far more resource-efficient than VMs.

---

### Secrets vs. Environment Variables

In this project, I used **environment variables** because they are simpler to implement. The key differences are:

| | Environment Variables | Docker Secrets |
|---|---|---|
| **Storage** | Plain text in `.env` file | Stored as a file, mounted at `/run/secrets/<name>` |
| **Security** | Risk of leaking via `.env` if `.gitignore` is not set up | More secure; not visible as plain text |
| **Inspection** | Visible via `docker inspect <container-id>` | Not exposed via inspect |

The main risk with environment variables is accidentally committing your `.env` file to a public repository. Always ensure `.env` is listed in `.gitignore`.

---

### Docker Network vs. Host Network

**Docker Network** (bridge mode) is the default. Docker creates a virtual network interface (`docker0`) during installation, and containers communicate through it. This network is isolated from the host machine's traffic — containers cannot sniff localhost traffic.

**Host Network** removes that isolation. The container shares the same network interface as the host machine, meaning it can interact with — and sniff — localhost traffic. This eliminates network isolation between the host and the container.

---

### Docker Volumes vs. Bind Mounts

Both Docker Volumes and Bind Mounts solve the **data persistence** problem — ensuring container data survives restarts or re-creation. The difference is in who manages the storage location on the host.

**Docker Volumes (Named Volumes)**
- Managed entirely by Docker
- Stored at `/var/lib/docker/volumes/<name>/_data` by default
- More secure and portable
- Listed and managed via Docker commands:
  ```bash
  docker volume ls
  docker volume create <vol-name>
  ```

**Bind Mounts**
- Managed by the user
- You specify the exact host path to bind to the container
- Useful for development (e.g., live code reloading), but less portable
