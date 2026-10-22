# ER Diagram

```mermaid
erDiagram
  USERS ||--o{ PORTFOLIOS : owns
  USERS ||--o{ WATCHLIST : maintains
  SECTORS ||--o{ STOCKS : classifies
  STOCKS ||--o{ HISTORICAL_STOCK_PRICES : has
  PORTFOLIOS ||--o{ PORTFOLIO_TRANSACTION : records
  STOCKS ||--o{ PORTFOLIO_TRANSACTION : references
  PORTFOLIOS ||--o{ HOLDINGS : contains
  STOCKS ||--o{ HOLDINGS : represents
  STOCKS ||--o{ WATCHLIST : appears_in
  PORTFOLIO_TRANSACTION ||--o{ TRANSACTION_AUDIT : audited_by
  USERS { number user_id PK }
  PORTFOLIOS { number portfolio_id PK number user_id FK varchar2 portfolio_name }
  STOCKS { number stock_id PK number sector_id FK varchar2 symbol }
  HISTORICAL_STOCK_PRICES { number price_id PK number stock_id FK date price_date number close_price }
  PORTFOLIO_TRANSACTION { number transaction_id PK number portfolio_id FK number stock_id FK varchar2 transaction_type }
  HOLDINGS { number holding_id PK number portfolio_id FK number stock_id FK number quantity }
  WATCHLIST { number watchlist_id PK number user_id FK number stock_id FK }
```

Relational notation: `PORTFOLIOS(portfolio_id PK, user_id FK, portfolio_name, description, created_at, updated_at)`; `HOLDINGS(holding_id PK, portfolio_id FK, stock_id FK, quantity, average_cost, cost_basis, updated_at)`; `PORTFOLIO_TRANSACTION(transaction_id PK, portfolio_id FK, stock_id FK, transaction_type, quantity, execution_price, transaction_date, fees, realized_pl)`.
