# R package management with renv

This project uses `renv` for reproducible R package management.

## Daily workflow

| Task | Command |
|------|---------|
| Install a new package | `install.packages("pkg")` then `renv::snapshot()` |
| Sync after pulling changes | `renv::restore()` |
| Check status | `renv::status()` |

## Key files

- `renv.lock` — commit this; records exact package versions
- `renv/library/` — do not commit; local package cache
- `.Rprofile` — auto-activates renv on project open (commit this)

## Setup (first time)

```r
install.packages("renv")
renv::init()
```

This creates `renv.lock` (the snapshot file) and `renv/library/` (local package cache).