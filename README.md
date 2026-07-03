<div align="center">

# 🐾 Huelli Database

### Enterprise PostgreSQL Database Infrastructure for the Huelli Platform

Database project that provides authentication, user management, OAuth2/OpenID Connect support, profiles, catalogs, security, and persistence for the Huelli ecosystem.

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-blue?logo=postgresql)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)
![pgAdmin](https://img.shields.io/badge/pgAdmin-4-blue)
![License](https://img.shields.io/badge/license-MIT-green)

</div>

---

# 📖 Overview

**Huelli Database** is the official PostgreSQL database project for the Huelli platform.

It provides:

- 🔐 Authentication & Authorization
- 👤 User Management
- 🌐 OAuth2 / OpenID Connect
- 🐶 Public User Profiles
- 🏢 Companies
- 🏠 Shelters
- 🛟 Rescuers
- 📚 Master Catalogs
- 🔒 Security Tokens
- 📊 Optimized Indexes
- 👁 SQL Views
- 🐳 Dockerized Development Environment

The project is intended to be consumed by the Huelli Backend microservices built with NestJS.

---

# 🏗 Architecture

```
                    +----------------+
                    |    pgAdmin     |
                    | localhost:5050 |
                    +--------+-------+
                             |
                             |
                     Docker Network
                             |
+--------------------------------------------------------+
|                                                        |
|                 PostgreSQL 17                          |
|                                                        |
|   Users                                                |
|   Profiles                                             |
|   OAuth Identities                                     |
|   Companies                                            |
|   Shelters                                             |
|   Rescuers                                             |
|   Security                                             |
|   Views                                                |
|                                                        |
+--------------------------------------------------------+

```

---

# 📂 Project Structure

```
HUELLI-DATABASE
│
├── docker-compose.yml
├── .env
│
├── postgres
│   ├── backups
│   ├── data
│   └── init
│       ├── 001_extensions.sql
│       ├── 002_catalogs.sql
│       ├── 003_security.sql
│       ├── 004_users.sql
│       ├── 005_profiles.sql
│       ├── 006_companies.sql
│       ├── 007_tokens.sql
│       ├── 008_indexes.sql
│       ├── 009_seed.sql
│       └── 010_views.sql
│
└── pgadmin
    ├── servers.json
    └── pgpass
```

---

# 🚀 Requirements

- Docker Desktop
- Docker Compose
- Git

---

# ⚙ Environment Variables

Create the `.env` file.

```env
POSTGRES_DB=huelli_db

POSTGRES_USER=huelli

POSTGRES_PASSWORD=Huelli2026!

PGADMIN_EMAIL=admin@huelli.com

PGADMIN_PASSWORD=Admin2026!
```

---

# 🚀 Start the Environment

```bash
docker compose up -d
```

---

# 🛑 Stop

```bash
docker compose down
```

---

# 🔄 Restart

```bash
docker compose restart
```

---

# 📋 View Logs

```bash
docker compose logs -f postgres
```

---

# 🗑 Recreate Database

Only if you want to lose all local data.

```bash
docker compose down
```

Delete

```
postgres/data
```

Then

```bash
docker compose up -d
```

---

# 🌐 Access pgAdmin

```
http://localhost:5050
```

Credentials

```
Email

admin@huelli.com
```

```
Password

Admin2026!
```

---

# 🗄 PostgreSQL Connection

External tools

| Property | Value |
|-----------|-------|
| Host | localhost |
| Port | 5432 |
| Database | huelli_db |
| User | huelli |
| Password | Huelli2026! |

---

# 🐳 Connection from Docker Containers

Any container inside the Docker network must use:

```
Host

postgres
```

Example

```
postgresql://huelli:Huelli2026!@postgres:5432/huelli_db
```

---

# 📜 Initialization Flow

When PostgreSQL starts for the first time it automatically executes:

```
001_extensions.sql

002_catalogs.sql

003_security.sql

004_users.sql

005_profiles.sql

006_companies.sql

007_tokens.sql

008_indexes.sql

009_seed.sql

010_views.sql
```

These scripts are executed **only once**.

If the `postgres/data` directory already contains a database, PostgreSQL preserves the existing data and does not execute the initialization scripts again.

---

# 🔐 Authentication Model

Supported authentication methods:

- Local Login
- Google OAuth2
- Apple Login
- Facebook Login
- Microsoft Login

Each user can have multiple authentication identities while maintaining a single Huelli account.

---

# 📚 Technology Stack

| Technology | Version |
|------------|---------|
| PostgreSQL | 17 |
| Docker | Latest |
| pgAdmin | Latest |
| SQL | PostgreSQL |
| OAuth | OAuth2 / OpenID Connect |

---

# 🔮 Roadmap

- Flyway Migration Support
- Prisma Migration Support
- Automatic Backups
- Spatial Search (PostGIS)
- Full Text Search
- Pet Module
- Community Module
- Notifications Module
- Chat Module

---

# 👨‍💻 Author

**Carlos Rossi**

Solutions Architect

Multi Cloud | AWS | Azure | GCP

---

# 📄 License

MIT License
