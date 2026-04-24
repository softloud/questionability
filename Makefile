.PHONY: db

db:
	psql -h localhost -U qnuser -d qndb

dagster: ## Start Dagster UI
	@echo "🎯 Starting Dagster UI..."
	@DAGSTER_HOME=$(PWD)/dagster_qn/dagsterdat uv run dagster dev -m dagster_qn
