# Bare Bones Local PostgreSQL Setup Guide

## 1. Install PostgreSQL

```bash
sudo apt update && sudo apt install postgresql postgresql-contrib
```

## 2. Start PostgreSQL Service

```bash
sudo systemctl start postgresql
```

## 3. Switch to the postgres User

```bash
sudo -i -u postgres
```

## 4. Create a New Database

```bash
createdb <database_name>
```

## 5. Create a New User (Optional)

```bash
createuser --interactive
```

# If you want to set a password for your user:

## 6. Set a Password for Your User

1. Access the PostgreSQL shell:

```bash
psql
```

2. Set the password (replace `<username>` and `<password>`):

```sql
ALTER USER <username> WITH PASSWORD '<password>';
```

## 7. Access the Database

```bash
psql <database_name>
```

## 8. Exit psql

```bash
\q
```

---

This guide now uses generic placeholders for usernames and passwords. Store credentials securely (e.g., in 1Password) and update your dbt profile accordingly.
