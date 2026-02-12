# Using uv for Python Environment Management

This project uses [uv](https://github.com/astral-sh/uv) for fast Python package management.

## Getting Started

1. **Set up a virtual environment** (if not already done):
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   ```

2. **Install uv** (if not already installed):
   ```bash
   pipx install uv
   # or
   pip install uv
   ```

3. **Install dependencies**:
   ```bash
   uv pip install -r requirements.txt
   ```

4. **Add new packages**:
   ```bash
   uv pip install <package-name>
   uv pip freeze > requirements.txt
   ```

5. **Sync environment** (to match requirements.txt):
   ```bash
   uv pip sync requirements.txt
   ```

## Notes
- Always activate your virtual environment before running uv commands.
- Do not commit the `.venv/` directory to version control.
