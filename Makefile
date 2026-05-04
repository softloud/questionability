.PHONY: db

db:
	psql -h localhost -U qnuser -d qndb

dagster: ## Start Dagster UI
	@echo "🎯 Starting Dagster UI..."
	@bash -c "source .env && uv run dagster dev -m dagster_qn"
