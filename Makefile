name = Inception

all: up

up: setup
	@printf "Building configuration...\n"
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	@printf "Stopping configuration...\n"
	@docker-compose -f ./srcs/docker-compose.yml down

start:
	@docker-compose -f ./srcs/docker-compose.yml start

setup:
	sudo mkdir -p /home/ccompote/mariadb-data
	sudo mkdir -p /home/ccompote/wordpress-data

clean:	down
	@printf "Cleaning configuration...\n"
	@docker system prune -a

fclean:
	@printf "Full cleaning all configurations of docker\n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force

.PHONY : all build down clean fclean
