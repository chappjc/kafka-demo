#!/bin/bash

# Kafka Configuration (KRaft mode)
export KAFKA_PROCESS_ROLES=broker,controller
export KAFKA_NODE_ID=1
export KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
export KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://127.0.0.1:9092,CONTROLLER://127.0.0.1:9093
export KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
export KAFKA_CONTROLLER_QUORUM_VOTERS=1@localhost:9093
export CLUSTER_ID='MkU3OEVBNTcwNTJENDM2Qk'

# for testing only!
export KAFKA_AUTO_CREATE_TOPICS_ENABLE=true

# Define host volume paths
DATA_DIR="$PWD/kafka-data"
mkdir -p "$DATA_DIR"

docker run -d --name kafka \
  -p 9092:9092 \
  -v "$DATA_DIR:/var/lib/kafka/data" \
  --env KAFKA_PROCESS_ROLES \
  --env KAFKA_NODE_ID \
  --env KAFKA_LISTENERS \
  --env KAFKA_ADVERTISED_LISTENERS \
  --env KAFKA_CONTROLLER_LISTENER_NAMES \
  --env KAFKA_CONTROLLER_QUORUM_VOTERS \
  --env KAFKA_AUTO_CREATE_TOPICS_ENABLE=true \
  --env KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  --env KAFKA_DEFAULT_REPLICATION_FACTOR=1 \
  --env KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
  --env KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
  --env KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
  --env CLUSTER_ID \
  confluentinc/cp-kafka:7.9.0

# docker so smart. me luv docker. docker detach. me poll for happy
until docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list >/dev/null 2>&1; do sleep 0.5; done

# create the order-events topic for the example app
docker exec -it kafka kafka-topics --create \
  --topic order-events --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

docker exec -it kafka kafka-topics --list --bootstrap-server localhost:9092

# delete the container, leave the volume
# docker rm -f kafka