name = Inception

ENV=PATH

all: up

up: setup
	 ${ENV} docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	${ENV} docker-compose -f ./srcs/docker-compose.yml down

start:
	${ENV} docker-compose -f ./srcs/docker-compose.yml start

setup:
	sudo mkdir -p /home/ccompote/
	sudo mkdir -p /home/ccompote/
	sudo mkdir -p /home/ccompote/mariadb-data
	sudo mkdir -p /home/ccompote/wordpress-data

clean:
	sudo rm -rf /home/ccompote/

fclean:
	docker system prune -f -a --volumes
	docker volume rm srcs_mariadb-data srcs_wordpress-data
