package main

import (
	"context"
	"fmt"

	"github.com/segmentio/kafka-go"
)

func main() {
	reader := kafka.NewReader(kafka.ReaderConfig{
		Brokers: []string{"localhost:9092"},
		GroupID: "order-processor",
		Topic:   "order-events",
	})
	defer reader.Close()

	fmt.Println("Consumer started...")
	for {
		msg, err := reader.ReadMessage(context.Background())
		if err != nil {
			fmt.Printf("Error reading message: %v\n", err)
			break
		}
		fmt.Printf("Consumed event: key=%s, value=%s\n", string(msg.Key), string(msg.Value))
	}
}
