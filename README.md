# Portfolio Management Database System

Oracle-backed JavaFX application for DBMS Lab Mini Project, Phase II. It uses an immutable transaction ledger, a database-maintained current-holdings table, stored historical prices, and PL/SQL procedures for buy/sell integrity.

## Prerequisites

- JDK 17 or newer and Maven 3.9+.
- Oracle Database 19c+ or Oracle Database Free, plus SQL*Plus or SQLcl.
- A schema user with permission to create tables, indexes, procedures, functions, and triggers.

## Configure Oracle

Copy `.env.example` to `.env` and replace only the values after `=`. `.env` is ignored by Git. Alternatively, set `ORACLE_JDBC_URL`, `ORACLE_DB_USER`, and `ORACLE_DB_PASSWORD` in the environment. The app never displays a password.

In SQL*Plus, execute scripts in this exact order:

```sql
@sql/01_create_schema.sql
@sql/02_constraints_and_indexes.sql
@sql/03_create_audit_objects.sql
@sql/04_create_procedures.sql
@sql/05_create_functions.sql
@sql/06_create_triggers.sql
@sql/07_seed_data.sql
@sql/08_verification_queries.sql
```

The seed data is deterministic teaching data—not a feed of current NSE prices. `10_reset_demo_data.sql` deletes all demonstration rows and must be used only in a disposable schema.

## Build and run

```powershell
mvn clean test
mvn javafx:run
```

On Windows use `scripts\run.bat`; on Linux/macOS use `sh scripts/run.sh`. The dashboard remains honest when Oracle is unavailable: it shows a connection error instead of mock numbers. Use **Settings** to test connectivity.

## Architecture

`config` owns environment loading and JDBC connection creation; `dao` owns parameterized reads and simple persistence; `service` calls PL/SQL with callable statements; JavaFX composes the responsive desktop interface. The seeded UI uses user id `1` only for the lab demonstration; all core records still retain relational ownership.

See [docs/PROJECT_OVERVIEW.md](docs/PROJECT_OVERVIEW.md), [docs/DATABASE_DESIGN.md](docs/DATABASE_DESIGN.md), [docs/ER_DIAGRAM.md](docs/ER_DIAGRAM.md), [docs/PL_SQL_REFERENCE.md](docs/PL_SQL_REFERENCE.md), [docs/TESTING.md](docs/TESTING.md), and [docs/FINAL_REPORT.md](docs/FINAL_REPORT.md).

## Troubleshooting

`java` or `mvn` not found means install a JDK and Maven, then reopen the terminal. `ORA-` errors are surfaced as safe user messages; use `sql/08_verification_queries.sql` to diagnose schema setup. A duplicate watchlist entry is expected to be rejected by `UQ_WATCHLIST_USER_STOCK`; an oversell is rejected by `ADD_SELL_TRANSACTION` without inserting a ledger row.
