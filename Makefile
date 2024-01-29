name = Inception
ENV_FILE := ./srcs/.env

all: up

up: setup
	@printf "Building configuration...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file $(ENV_FILE) up -d --build

down:
	@printf "Stopping configuration...\n"
	@docker-compose -f ./srcs/docker-compose.yml down

start:
	@docker-compose -f ./srcs/docker-compose.yml start

setup:
	sudo mkdir -p /home/${USER}/data/db-data
	sudo mkdir -p /home/${USER}/data/wp-data

clean:	down
	@printf "Cleaning configuration...\n"
	@docker system prune -a

fclean: clean
	@printf "Full cleaning all configurations of docker\n"
	@docker volume rm `docker volume ls -q`

.PHONY : all build down clean fclean
