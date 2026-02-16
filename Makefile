.PHONY: setup ci lint test
.PHONY: up down logs
.PHONY: fe-dev be-dev pf-dev pf-worker
.PHONY: fe-lint be-lint fe-test be-test

setup:
	cd apps/fe && npm install
	cd apps/be && go mod tidy

# ---- Compose orchestration ----
up:
	docker compose up --build

down:
	docker compose down

logs:
	docker compose logs -f --tail=200

# ---- App-local dev ----
fe-dev:
	cd apps/fe && npm run dev

be-dev:
	cd apps/be && go run ./cmd/api

pf-dev:
	cd apps/problem-factory && uvicorn app.main:app --reload --port 8090

pf-worker:
	cd apps/problem-factory && celery -A app.workers.celery_app.celery_app worker -l info

# ---- Quality gates by app ----
fe-lint:
	cd apps/fe && npm run lint

be-lint:
	cd apps/be && golangci-lint run

fe-test:
	cd apps/fe && npm run test -- --run

be-test:
	cd apps/be && go test ./...

lint: fe-lint be-lint

test: fe-test be-test

ci: lint test
