DB_IMAGE_NAME=srcs-mariadb
WP_IMAGE_NAME=srcs-wordpress
NGX_IMAGE_NAME=srcs-nginx

DB_CONT_NAME=srcs-mariadb-1
WP_CONT_NAME=srcs-wordpress-1
NGX_CONT_NAME=srcs-nginx-1

# Start containers
all:
	sudo docker compose -f ./srcs/docker-compose.yml up -d --build

# Remove images only
clean:
	sudo docker rmi $(DB_IMAGE_NAME) $(WP_IMAGE_NAME) $(NGX_IMAGE_NAME) --force || true

# Stop everything, remove containers, volumes, networks, and images
fclean: clean
	sudo docker compose -f ./srcs/docker-compose.yml down -v --rmi all --remove-orphans
	sudo docker system prune -af

# Rebuild everything from scratch
re: fclean all
