COMPOSE_FILE = ./srcs/docker-compose.yml
LOCAL_DATA_PATH = /home/yanflous/data

setup:
	@sudo mkdir -p $(LOCAL_DATA_PATH)/mariadb
	@sudo mkdir -p $(LOCAL_DATA_PATH)/wordpress

# -d / detached mode
# --build / re-build  image
up: setup
	@sudo docker compose -f $(COMPOSE_FILE) up -d --build

# start runing containers
start:
	@sudo docker compose -f $(COMPOSE_FILE) start

# stop runing containers
stop:
	@sudo docker compose -f $(COMPOSE_FILE) stop

# remove just (container + network)
down:
	@sudo docker compose -f $(COMPOSE_FILE) down

# removes all images associated with the compose + (container + network)
clean: down
	@sudo docker compose -f $(COMPOSE_FILE) down --rmi all

# removes all images(clean) + containers + network + volumes(-v)
fclean: clean
	@sudo docker compose -f $(COMPOSE_FILE) down -v
	@sudo rm -rf $(LOCAL_DATA_PATH)/mariadb
	@sudo rm -rf $(LOCAL_DATA_PATH)/wordpress

re: fclean up

status:
	@sudo docker compose -f $(COMPOSE_FILE) ps -a

# -f / follows the logs in real time
logs:
	@sudo docker compose -f $(COMPOSE_FILE) logs -f

logs-mariadb:
	@sudo docker compose -f $(COMPOSE_FILE) logs mariadb

logs-wordpress:
	@sudo docker compose -f $(COMPOSE_FILE) logs wordpress

logs-nginx:
	@sudo docker compose -f $(COMPOSE_FILE) logs nginx

exec-mariadb:
	@sudo docker exec -it mariadb bash

exec-wordpress:
	@sudo docker exec -it wordpress bash

exec-nginx:
	@sudo docker exec -it nginx bash

help:
	@printf "\033[1;36m%-20s\033[0m %s\n" "up" "get up the docker compose config"
	@printf "\033[1;36m%-20s\033[0m %s\n" "start" "start docker container"
	@printf "\033[1;36m%-20s\033[0m %s\n" "stop" "stop docker container"
	@printf "\033[1;36m%-20s\033[0m %s\n" "down" "remove containers && networks"
	@printf "\033[1;36m%-20s\033[0m %s\n" "clean" "remove images"
	@printf "\033[1;36m%-20s\033[0m %s\n" "fclean" "remove all volumes && containers && networks"
	@printf "\033[1;36m%-20s\033[0m %s\n" "re" "clean up and restart over again"
	@printf "\033[1;36m%-20s\033[0m %s\n" "status" "status about the containers" 
	@printf "\033[1;36m%-20s\033[0m %s\n" "logs" "logs about health of containers"
	@printf "\033[1;36m%-20s\033[0m %s\n" "logs-mariadb" "logs about mariadb"
	@printf "\033[1;36m%-20s\033[0m %s\n" "logs-wordpress" "logs about wordpress"
	@printf "\033[1;36m%-20s\033[0m %s\n" "logs-nginx" "logs about nginx"
	@printf "\033[1;36m%-20s\033[0m %s\n" "exec-mariadb" "exec mariadb container"
	@printf "\033[1;36m%-20s\033[0m %s\n" "exec-wordpress" "exec wordpress container"
	@printf "\033[1;36m%-20s\033[0m %s\n" "exec-nginx" "exec nginx container"
