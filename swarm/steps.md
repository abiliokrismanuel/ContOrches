# install sh

# inisiasi swarm
docker swarm init
docker swarm join-token manager
docker swarm join-token worker

# see all serv
docker service ps $(docker service ls -q)

# ress
docker service update --force deploy-micro_<nama_service>

# ress all
for service in $(docker stack services deploy-micro --format "{{.Name}}"); do
  docker service update --force $service;
done