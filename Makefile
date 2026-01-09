COMPOSE_FILE = ./srcs/docker-compose.yml
LOCAL_DATA_PATH = /home/yanflous/data

setup:
	@sudo mkdir -p $(LOCAL_DATA_PATH)/mariadb
	@sudo mkdir -p $(LOCAL_DATA_PATH)/wordpress

up: setup
	@sudo docker compose -f $(COMPOSE_FILE) up -d --build

start:
	@sudo docker compose -f $(COMPOSE_FILE) start

stop:
	@sudo docker compose -f $(COMPOSE_FILE) stop

down:
	@sudo docker compose -f $(COMPOSE_FILE) down

clean: down
	@sudo docker compose -f $(COMPOSE_FILE) down --rmi all

fclean: clean
	@sudo docker compose -f $(COMPOSE_FILE) down -v
# 	remve all data about unused or stoped continers, netwoks, images etc...
	@sudo docker system prune
	@sudo docker image prune
	@sudo rm -rf $(LOCAL_DATA_PATH)/mariadb
	@sudo rm -rf $(LOCAL_DATA_PATH)/wordpress

re: fclean up

status:
	@sudo docker compose -f $(COMPOSE_FILE) ps -a

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
	@echo "up					get up the docker compose config"
	@echo "start				start docker container"
	@echo "stop					start docker container"
	@echo "down					remove containers && networks"
	@echo "clean				remove images"
	@echo "fclear				remove all volumes && containers && networks"
	@echo "re					clean up and restart over again"
	@echo "status				status about the containers" 
	@echo "logs					logs about health of containers"
	@echo "logs-mariadb			logs about mariadb"
	@echo "logs-wordpress		logs about wordpress"
	@echo "logs-nginx			logs about nginx"
	@echo "exec-mariadb			exec mariadb container"
	@echo "exec-wordpress		exec wordpress container"
	@echo "exec-nginx			exec nginx container"
