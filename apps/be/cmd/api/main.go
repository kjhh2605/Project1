package main

import (
	"log"

	"github.com/gnar/project1/be/internal/config"
	"github.com/gnar/project1/be/internal/server"
)

func main() {
	cfg := config.Load()
	r := server.New(cfg)

	log.Printf("starting API server on :%s", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatal(err)
	}
}
