# Run Cassandra cluster on GCP using VM (no k8s)
'''sh
gcloud-start-cluster.sh
'''

# Run a Cassandra node in a Docker container
run a standalone container with the following command (_replace /persistent/local/storage with an existing local path_)

```
docker run -d -p 7000:7000 -p 7001:7001 -p 7199:7199 -p 9042:9042 -p 9160:9160 -v /persistent/local/storage:/var/lib/cassandra --name csnd cassandra:2.2
```

# Simulate a Cassandra cluster with 3 Docker containers

A three node Cassandra cluster can be simulated with docker containers by downloading the docker-compose.yml file from this repository and then running

```
docker-compose up -d
```
(this will run if docker and docker-compose are already installed)

Otherwise on a "fresh" Debian based system run the following command

```
wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/cluster-setup.sh| bash -s
```
to download and install docker and docker-compose and then run the docker-compose up -d command

Once the three nodes are running (check with ```docker ps -a```), run 

```
docker exec -ti `docker ps --format '{{.Names}}' | grep node01` bash
```
to log into the first container (called {something}_node01_1 - make sure that there are not other containers having node01 in their name) and then run 
```

wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/get-data.sh |bash -s
```
to download all the data files into /tmp

## Restarting the containers

If the containers have stopped, simply run
```
docker-compose up -d
```
In the same directory where you run the first install step (the one with cluster-setup.sh, there should be a file called docker-compose.yml)

## Running the containers without docker-compose
First, start a single node

```
docker run -d --name node01 academyofdata/cassandra
```

then, for each additional node, run 

```
docker run -d --link node01:node01 --name node02 -e "CASSANDRA_SEEDS=node01" academyofdata/cassandra
```


### Installing wget

If  at any of the steps above you get a message saying "bash: wget: command not found", run the following commands

```
apt-get update
apt-get install -y wget
```
### get_num_processes
If you get a **get_num_processes() takes no keyword arguments** error, get out of cqlsh (but stay in the container shell, not on the host system) and run

```
rm /usr/lib/pymodules/python2.7/cqlshlib/copyutil.so
```

# Running a container with all the MovieLens (and other exercises) data already preloaded

Start a single Cassandra node with the following command

```
docker run -d -p 7000:7000 -p 7001:7001 -p 7199:7199 -p 9042:9042 -p 9160:9160 --name aod_cass academyofdata/cassandra
```

Once the node is up-and-running you'll be able to access cqlsh the 'regular' way, but in addition to the 'stock' Cassandra image, in /data you'll have the csv for MovieLens & weather data.
