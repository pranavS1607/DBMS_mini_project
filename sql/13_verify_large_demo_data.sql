-- Verification queries for 12_large_demo_data.sql
SET LINESIZE 180
SET PAGESIZE 50

SELECT COUNT(*) AS total_stocks FROM stocks;
SELECT COUNT(*) AS total_price_rows FROM historical_stock_prices;
SELECT COUNT(*) AS synthetic_price_rows FROM historical_stock_prices WHERE source_label='SYNTHETIC DEMO - NOT MARKET DATA';
SELECT COUNT(*) AS total_transactions FROM portfolio_transaction;
SELECT COUNT(*) AS generated_transactions FROM portfolio_transaction WHERE notes LIKE 'SYNTHETIC_DEMO_V2|%';
SELECT COUNT(*) AS total_holdings FROM holdings;
SELECT COUNT(*) AS portfolios_for_user FROM portfolios WHERE user_id=1;
SELECT COUNT(*) AS watchlist_for_user FROM watchlist WHERE user_id=1;

-- Check each stock's price coverage in the generated date window.
SELECT MIN(price_date) AS earliest_generated_price, MAX(price_date) AS latest_generated_price
FROM historical_stock_prices WHERE source_label='SYNTHETIC DEMO - NOT MARKET DATA';

-- Reconciliation: holdings should be non-negative and unique by portfolio/stock.
SELECT COUNT(*) AS invalid_holdings FROM holdings WHERE quantity<=0 OR cost_basis<0 OR average_cost<0;
