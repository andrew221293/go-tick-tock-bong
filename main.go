package main

import (
	"fmt"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

var (
	tickMessage = getEnv("TICK_MESSAGE", "tick")
	tockMessage = getEnv("TOCK_MESSAGE", "tock")
	bongMessage = getEnv("BONG_MESSAGE", "bong")
)

func getEnv(key, defaultValue string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultValue
}

func printMessages(wg *sync.WaitGroup) {
	defer wg.Done()
	ticker := time.NewTicker(1 * time.Second)
	tockTicker := time.NewTicker(1 * time.Minute)
	bongTicker := time.NewTicker(1 * time.Hour)
	defer ticker.Stop()
	defer tockTicker.Stop()
	defer bongTicker.Stop()

	for {
		select {
		case <-ticker.C:
			fmt.Println(tickMessage)
		case <-tockTicker.C:
			fmt.Println(tockMessage)
		case <-bongTicker.C:
			fmt.Println(bongMessage)
		}
	}
}

func main() {
	var wg sync.WaitGroup
	wg.Add(1)
	go printMessages(&wg)

	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		for {
			select {
			case sig := <-sigChan:
				fmt.Printf("Received signal: %s, exiting...\n", sig)
				os.Exit(0)
			}
		}
	}()

	// Run for 3 hours
	time.Sleep(3 * time.Hour)
	fmt.Println("Completed 3 hours. Exiting...")
}
