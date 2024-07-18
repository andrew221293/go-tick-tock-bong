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
	tickMessage = "tick"
	tockMessage = "tock"
	bongMessage = "bong"
)

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

	// User input handling to change messages
	go func() {
		for {
			var command, newValue string
			fmt.Println("Enter command (tick, tock, bong) followed by new value:")
			_, err := fmt.Scanf("%s %s", &command, &newValue)
			if err != nil {
				fmt.Println("Invalid input. Usage: <command> <new value>")
				continue
			}

			switch command {
			case "tick":
				tickMessage = newValue
			case "tock":
				tockMessage = newValue
			case "bong":
				bongMessage = newValue
			default:
				fmt.Println("Unknown command. Valid commands are: tick, tock, bong")
			}
		}
	}()

	// Run for 3 hours
	time.Sleep(3 * time.Hour)
	fmt.Println("Completed 3 hours. Exiting...")
}
