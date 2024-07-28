package main

import (
	"fmt"
	"json"
	"log"
	"os/exec"
)

func main() {
	// Check if the application is installed.
	checkApplication("yt-dlp")
}

// Check if an application is installed
func checkApplication(appName string) bool {
	// Check if a given application is running.
	cmd := exec.Command(appName)
	err := cmd.Run()
	if err != nil {
		log.Println(err)
	}
}
