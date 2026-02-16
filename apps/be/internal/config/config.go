package config

import "os"

type Config struct {
	Port       string
	CORSOrigin string
	AppEnv     string
}

func Load() Config {
	return Config{
		Port:       getenv("PORT", "8080"),
		CORSOrigin: getenv("CORS_ORIGIN", "http://localhost:3000"),
		AppEnv:     getenv("APP_ENV", "local"),
	}
}

func getenv(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
