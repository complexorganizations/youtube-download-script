package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"os/exec"
	"runtime"
)

func main() {
	//
}

// Check if the list of required apps are already installed
func checkAllApplication() {
	// List of all the required apps on the system before we can process it.
	userApps := []string{"yt-dlp", "ffmpeg", "fprobe", "date", "fdupes"}
	// Loop though the apps and check if they are installed.
	for _, app := range userApps {
		fmt.Println(checkApplication(app))
	}
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
	data, err := os.ReadFile(filePath)
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
