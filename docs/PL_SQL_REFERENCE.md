# PL/SQL Reference

## Procedures

`CREATE_PORTFOLIO(user_id, name, description, portfolio_id OUT)` validates the name and creates an owner-scoped portfolio. `ADD_BUY_TRANSACTION(...)` validates positive values, locks the open position when present, updates weighted-average basis, then inserts a ledger row. `ADD_SELL_TRANSACTION(...)` locks the position, rejects an oversell, reduces/removes the holding, calculates realised P/L, then inserts a ledger row. No procedure commits; JDBC controls the commit so a failure rolls back as one unit of work.

## Functions

`PORTFOLIO_COST_BASIS`, `PORTFOLIO_MARKET_VALUE`, `PORTFOLIO_UNREALIZED_PL`, and `PORTFOLIO_RETURN_PERCENTAGE` are reusable dashboard/report calculations. Market value uses each stock’s most recent stored price. Return returns zero when cost basis is zero.

## Triggers

`TRG_TRANSACTION_AUDIT` records inserts, updates, and deletes on the transaction ledger with actor, timestamp, quantities, and prices. `TRG_PRICE_DATE_GUARD` rejects a price record more than one day in the future. The audit trigger does not modify holdings and therefore avoids recursive or mutating-table behavior.

Java calls buy/sell with `CallableStatement` in `TransactionService`; Oracle errors are presented as user-safe messages. Examples and expected negative tests are in `sql/08_verification_queries.sql`.
