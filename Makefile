FILE= ./docker-compose.yml
NAMES = server
VLM = `docker volume ls -q`
all:
	docker-compose -f  $(FILE) up -d --build
	docker ps
	# yarn && yarn start:dev

clean:
	docker-compose -f $(FILE) down
rmimg:
	docker rmi -f $(NAMES)

rmvol:
	docker volume rm $(VLM)

fclean: clean  rmimg rmvol

re: fclean all