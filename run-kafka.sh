#!/bin/bash

# Kafka Configuration (KRaft mode)
export KAFKA_PROCESS_ROLES=broker,controller
export KAFKA_NODE_ID=1
export KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
export KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://127.0.0.1:9092
export KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
export KAFKA_CONTROLLER_QUORUM_VOTERS=1@localhost:9093
export CLUSTER_ID='MkU3OEVBNTcwNTJENDM2Qk'

# Define host volume paths
DATA_DIR="$PWD/kafka-data"
mkdir -p "$DATA_DIR"

docker run --name kafka \
  -p 9092:9092 \
  -v "$DATA_DIR:/var/lib/kafka/data" \
  --env KAFKA_PROCESS_ROLES \
  --env KAFKA_NODE_ID \
  --env KAFKA_LISTENERS \
  --env KAFKA_ADVERTISED_LISTENERS \
  --env KAFKA_CONTROLLER_LISTENER_NAMES \
  --env KAFKA_CONTROLLER_QUORUM_VOTERS \
  --env CLUSTER_ID \
  confluentinc/cp-kafka:7.9.0
