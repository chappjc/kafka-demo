package main

import (
	"context"
	"fmt"
	"math/rand"
	"time"

	"github.com/segmentio/kafka-go"
)

func main() {
	writer := kafka.NewWriter(kafka.WriterConfig{
		Brokers: []string{"localhost:9092"},
		Topic:   "order-events",
	})
	defer writer.Close()

	for range 10 {
		orderID := fmt.Sprintf("order-%06d", rand.Intn(1000))
		err := writer.WriteMessages(context.Background(), kafka.Message{
			Key:   []byte(orderID),
			Value: []byte(fmt.Sprintf("OrderCreated:%s", orderID)),
		})
		if err != nil {
			fmt.Printf("Failed to write message: %v\n", err)
		} else {
			fmt.Printf("Produced event: %s\n", orderID)
		}
		time.Sleep(500 * time.Millisecond) // Simulate time between orders
	}
}
