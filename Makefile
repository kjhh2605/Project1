.PHONY: setup dev lint test ci

setup:
	cd apps/fe && npm install
	cd apps/be && go mod tidy

dev:
	( cd apps/be && go run ./cmd/api ) & ( cd apps/fe && npm run dev )

lint:
	cd apps/fe && npm run lint
	cd apps/be && golangci-lint run

test:
	cd apps/fe && npm run test -- --run
	cd apps/be && go test ./...

ci: lint test
