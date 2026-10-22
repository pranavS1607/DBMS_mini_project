-- DESTRUCTIVE: use only for a disposable lab schema. Review before running.
DELETE FROM transaction_audit;
DELETE FROM watchlist;
DELETE FROM portfolio_transaction;
DELETE FROM holdings;
DELETE FROM historical_stock_prices;
DELETE FROM portfolios;
DELETE FROM stocks;
DELETE FROM sectors;
DELETE FROM users;
COMMIT;
PROMPT Demonstration rows removed. Re-run 07_seed_data.sql after the schema objects remain installed.
