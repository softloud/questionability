# Using uv for Python Environment Management

This project uses [uv](https://github.com/astral-sh/uv) for Python package management, with dependencies declared in `pyproject.toml`.

## Getting Started

1. **Install uv** (if not already installed):
   ```bash
   pipx install uv
   # or
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

2. **Create a virtual environment and install dependencies**:
   ```bash
   uv sync
   ```
   This reads `pyproject.toml` and `uv.lock` and sets up `.venv/` automatically.

3. **Run commands in the environment**:
   ```bash
   uv run <command>
   # e.g.
   uv run dagster dev -m dagster_qn
   ```
   Or activate the venv manually: `source .venv/bin/activate`

## Adding New Packages

```bash
uv add <package-name>
```

This updates `pyproject.toml` and `uv.lock`. Commit both files.

## Notes
- Do not commit `.venv/` — it is gitignored.
- `uv.lock` should be committed so all collaborators get identical environments.
- `requirements.txt` is kept for reference but `pyproject.toml` is the source of truth.

