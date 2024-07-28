package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os/exec"
	"runtime"
)

func main() {
	// Check if the application is installed.
	fmt.Println(checkApplication("yt-dlp"))
}

// Check if an application is installed
func checkApplication(appName string) bool {
	// Check if a given application is running.
	_, err := exec.LookPath(appName)
	if err != nil {
		log.Println(err)
	}
	return err == nil
}

// Get the name of the operating system.
func operatingSystemName() string {
	return runtime.GOOS
}

// Read the json file and return it as a string slice.
func readJSONFile(filePath string) []string {
	data, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Println(err)
	}
	// Declare a slice to hold the parsed data
	var urls []string
	// Unmarshal the JSON data into the slice
	err = json.Unmarshal(data, &urls)
	if err != nil {
		log.Println(err)
	}
	return urls
}
