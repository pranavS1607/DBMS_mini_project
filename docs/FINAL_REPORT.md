# LAB NO.: 12 Mini Project (Phase II)

**Date:** ____________________  
**Title:** Portfolio Management Database System

## 1. Team Members

1. Pranav Suryadevara — Registration No. 251090580090
2. Sanvi Kulkarni — Registration No. 251090580001
3. Erwin Clint Olivera — Registration No. 251090580002

## 2. Abstract

This project implements a database-driven desktop system for managing equity portfolios. It records portfolios, stocks, sectors, dated prices, watchlists, and a transaction ledger. Oracle PL/SQL procedures make buy and sell operations atomic while maintaining current holdings under a weighted-average cost policy. JavaFX provides a professional desktop interface and Oracle JDBC provides the persistence boundary. The application uses seeded demonstration prices and does not claim live market-data capability.

## 3. Problem Statement

Investment records require connected information: a portfolio belongs to an owner, a trade references a stock, prices change by date, and the current holding must remain consistent with its history. The system must validate transactions, prevent overselling, keep historical audit evidence, present portfolio/sector reports, and connect Java to Oracle safely without hard-coded credentials.

## 4. ER Diagram, Relations, and Sample Data

The editable ER diagram is in [ER_DIAGRAM.md](ER_DIAGRAM.md). The principal relations are `USERS`, `SECTORS`, `STOCKS`, `PORTFOLIOS`, `HISTORICAL_STOCK_PRICES`, `PORTFOLIO_TRANSACTION`, `HOLDINGS`, `WATCHLIST`, and `TRANSACTION_AUDIT`. Example seed rows include `TCS`, `INFY`, `HDFCBANK`, `RELIANCE`, and `ITC`, owned by the demonstration user and priced on October 2026 dates. The exact executable rows are in `sql/07_seed_data.sql`.

## 5. DDL and Integrity Constraints

The executable DDL is `sql/01_create_schema.sql` and `sql/02_constraints_and_indexes.sql`. It defines primary/foreign keys, unique owner-portfolio and user-watchlist relationships, positive monetary checks, a buy/sell type check, price uniqueness by stock/date, and targeted indexes. See [DATABASE_DESIGN.md](DATABASE_DESIGN.md) for the data dictionary and 3NF rationale.

## 6. SQL Queries

Twenty-five Oracle queries are provided in `sql/09_demo_queries.sql`, with an exact purpose comment before each query. They demonstrate joins, aggregation, subqueries, correlated analysis, valuations, allocations, history, audit, and reconciliation. `sql/08_verification_queries.sql` separately contains negative integrity tests.

## 7. UI Design and Screenshots

The JavaFX interface provides Dashboard, Portfolios, Stock Explorer, Buy/Sell, Holdings, Watchlist, Transactions, Price History, Analytics, About, and Settings. It uses a dark navy navigation rail, a light workspace, teal action accents, responsive layouts, validation alerts, and explicit connection status. Screenshots are pending because the local computer has neither Java/Maven nor a configured Oracle endpoint. After setup, capture actual views under `docs/screenshots/` using the checklist in [APPLICATION_GUIDE.md](APPLICATION_GUIDE.md); conceptual or generated images must not be substituted.

## 8. PL/SQL Procedures, Functions, and Triggers

`CREATE_PORTFOLIO`, `ADD_BUY_TRANSACTION`, and `ADD_SELL_TRANSACTION` are defined in `sql/04_create_procedures.sql`. The buy procedure incorporates fees into weighted-average cost; the sell procedure locks the holding and rejects a quantity above the position. Reusable market-value, cost-basis, unrealised-P/L, and return functions are in `sql/05_create_functions.sql`. The audit and historical-price guards are in `sql/06_create_triggers.sql`. A full explanation and JDBC calling location appear in [PL_SQL_REFERENCE.md](PL_SQL_REFERENCE.md).

## 9. Java Functional Design

`ConnectionFactory` loads safe configuration and opens an Oracle connection with auto-commit disabled. `PortfolioDao` and `MarketDao` use prepared statements. `TransactionService` uses `CallableStatement` to invoke the PL/SQL procedures; Java commits only after procedure success. `PortfolioApplication` coordinates JavaFX navigation, input validation, confirmation, safe error display, and database refresh. The complete source is in `src/main/java/edu/dbms/portfolio/` and is the source-code appendix for this report.

## 10. Testing, Limitations, and References

Static consistency review was completed. Maven/JUnit and Oracle integration execution remain pending because JDK/Maven and Oracle credentials are unavailable on the current machine; see [TESTING.md](TESTING.md) for exact next tests. The implementation is intentionally single-user in the displayed client, though ownership is relationally modelled. Seed quotes are educational records, not real-time data.

References: Silberschatz, Korth, Sudarshan, *Database System Concepts*, 6th ed.; Ivan Bayross, *SQL, PL/SQL*; Oracle Corporation, *PL/SQL Language Reference* (https://docs.oracle.com/); G. Reese, *Database Programming with JDBC and Java*, 2nd ed.; LearnDB (https://www.learndb.com/databases); OpenJFX documentation; Apache Maven documentation; Oracle JDBC documentation.
