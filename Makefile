# Variables
COMPOSE_FILE = ./srcs/docker-compose.yml
DATA_PATH = /home/yanflous/data

# Image names
DB_IMAGE = srcs-mariadb
WP_IMAGE = srcs-wordpress
NGX_IMAGE = srcs-nginx

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Default target
all: up

# Create data directories
create-dirs:
	@echo "$(YELLOW)Creating data directories...$(NC)"
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@echo "$(GREEN)Data directories created!$(NC)"

# Build and start containers
up: create-dirs
	@echo "$(GREEN)Building and starting containers...$(NC)"
	@sudo docker compose -f $(COMPOSE_FILE) up -d --build
	@echo "$(GREEN)Containers are running!$(NC)"

# Start containers (without building)
start:
	@echo "$(GREEN)Starting containers...$(NC)"
	@sudo docker compose -f $(COMPOSE_FILE) start

# Stop containers
stop:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	@sudo docker compose -f $(COMPOSE_FILE) stop

# Stop and remove containers
down:
	@echo "$(YELLOW)Stopping and removing containers...$(NC)"
	@sudo docker compose -f $(COMPOSE_FILE) down

# Clean: stop containers and remove images
clean: down
	@echo "$(YELLOW)Removing Docker images...$(NC)"
	@sudo docker rmi $(DB_IMAGE) $(WP_IMAGE) $(NGX_IMAGE) --force 2>/dev/null || true
	@echo "$(GREEN)Images removed!$(NC)"

# Full clean: remove everything including volumes and data
fclean: down
	@echo "$(RED)Performing full cleanup...$(NC)"
	@sudo docker compose -f $(COMPOSE_FILE) down -v --rmi all --remove-orphans
	@sudo docker system prune -af --volumes
	@echo "$(YELLOW)Cleaning data directories...$(NC)"
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@echo "$(GREEN)Full cleanup complete!$(NC)"

# Rebuild: full clean + build from scratch
re: fclean up

# Show container status
status:
	@echo "$(GREEN)Container Status:$(NC)"
	@sudo docker compose -f $(COMPOSE_FILE) ps

# Show logs
logs:
	@sudo docker compose -f $(COMPOSE_FILE) logs

# Follow logs in real-time
logs-f:
	@sudo docker compose -f $(COMPOSE_FILE) logs -f

# Show logs for specific service
logs-mariadb:
	@sudo docker compose -f $(COMPOSE_FILE) logs mariadb

logs-wordpress:
	@sudo docker compose -f $(COMPOSE_FILE) logs wordpress

logs-nginx:
	@sudo docker compose -f $(COMPOSE_FILE) logs nginx

# Execute commands inside containers
exec-mariadb:
	@sudo docker exec -it mariadb bash

exec-wordpress:
	@sudo docker exec -it wordpress bash

exec-nginx:
	@sudo docker exec -it nginx bash

# Help
help:
	@echo "$(GREEN)Available targets:$(NC)"
	@echo "  $(YELLOW)make$(NC) or $(YELLOW)make all$(NC)      - Build and start all containers"
	@echo "  $(YELLOW)make up$(NC)              - Same as 'make all'"
	@echo "  $(YELLOW)make start$(NC)           - Start stopped containers"
	@echo "  $(YELLOW)make stop$(NC)            - Stop running containers"
	@echo "  $(YELLOW)make down$(NC)            - Stop and remove containers"
	@echo "  $(YELLOW)make clean$(NC)           - Stop containers and remove images"
	@echo "  $(YELLOW)make fclean$(NC)          - Full cleanup (containers, images, volumes, data)"
	@echo "  $(YELLOW)make re$(NC)              - Full rebuild (fclean + up)"
	@echo "  $(YELLOW)make status$(NC)          - Show container status"
	@echo "  $(YELLOW)make logs$(NC)            - Show all logs"
	@echo "  $(YELLOW)make logs-f$(NC)          - Follow logs in real-time"
	@echo "  $(YELLOW)make logs-[service]$(NC)  - Show logs for specific service"
	@echo "  $(YELLOW)make exec-[service]$(NC)  - Execute bash in specific container"
	@echo "  $(YELLOW)make help$(NC)            - Show this help message"

.PHONY: all up start stop down clean fclean re status logs logs-f \
	logs-mariadb logs-wordpress logs-nginx exec-mariadb exec-wordpress \
	exec-nginx create-dirs help

# make              # Build and start (same as 'make up')
# make up           # Build and start containers
# make down         # Stop and remove containers
# make clean        # Stop containers + remove images
# make fclean       # Complete cleanup (everything!)
# make re           # Rebuild from scratch (fclean + up)
# make status       # Show container status
# make logs         # Show all logs
# make logs-f       # Follow logs live
# make logs-wordpress  # Show only WordPress logs
# make exec-wordpress  # Enter WordPress container
# make help         # Show all available commands