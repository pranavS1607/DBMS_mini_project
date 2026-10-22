# Database Design and Data Dictionary

The design is in 3NF: entities are stored once, repeating sector names are removed into `SECTORS`, price observations are isolated from `STOCKS`, and current holdings are a controlled, derived materialization of the ledger.

| Table | Purpose | Key constraints |
|---|---|---|
| `USERS` | Portfolio owners | PK `user_id`, unique email |
| `SECTORS` | Controlled classification | PK, unique name |
| `STOCKS` | Security master | PK, unique symbol, FK sector |
| `PORTFOLIOS` | Named owner portfolios | PK, FK user, unique owner/name |
| `HISTORICAL_STOCK_PRICES` | Stored dated prices | FK stock, unique stock/date, positive price |
| `PORTFOLIO_TRANSACTION` | Immutable buy/sell ledger | FKs, positive quantity/price, type check |
| `HOLDINGS` | Current open positions | unique portfolio/stock, positive quantity |
| `WATCHLIST` | User security interests | unique user/stock |
| `TRANSACTION_AUDIT` | Ledger change evidence | audit PK, actor and timestamp |

`HOLDINGS.cost_basis` and `average_cost` are deliberately derived values for responsive reporting. They are updated in the same Oracle transaction as the inserted ledger row by `ADD_BUY_TRANSACTION` and `ADD_SELL_TRANSACTION`; direct ad-hoc changes should be denied to the application user.

All monetary columns use `NUMBER(15,4)` or `NUMBER(18,4)`. Indexes target owner, portfolio/date, stock/date, price history, and watchlist lookup paths. `PORTFOLIOS` is intentionally not cascade-deleted: a portfolio with transactions must be handled through an explicit, documented correction workflow.
