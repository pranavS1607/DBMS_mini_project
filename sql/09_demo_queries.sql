-- 01. All portfolios and their current value.
SELECT portfolio_name,portfolio_market_value(portfolio_id) market_value FROM portfolios ORDER BY market_value DESC;
-- 02. Stock master with latest stored price.
SELECT s.symbol,s.company_name,se.sector_name,MAX(p.price_date) latest_date FROM stocks s JOIN sectors se ON se.sector_id=s.sector_id LEFT JOIN historical_stock_prices p ON p.stock_id=s.stock_id GROUP BY s.symbol,s.company_name,se.sector_name;
-- 03. Stocks matching a company-name pattern.
SELECT symbol,company_name FROM stocks WHERE UPPER(company_name) LIKE UPPER('%TECH%');
-- 04. Number of stocks per sector.
SELECT se.sector_name,COUNT(*) stock_count FROM sectors se LEFT JOIN stocks s ON s.sector_id=se.sector_id GROUP BY se.sector_name;
-- 05. Current holdings with latest market price.
SELECT p.portfolio_name,s.symbol,h.quantity,h.average_cost,h.cost_basis,lp.close_price,h.quantity*lp.close_price market_value FROM holdings h JOIN portfolios p ON p.portfolio_id=h.portfolio_id JOIN stocks s ON s.stock_id=h.stock_id JOIN (SELECT stock_id,close_price,ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY price_date DESC) rn FROM historical_stock_prices) lp ON lp.stock_id=s.stock_id AND lp.rn=1;
-- 06. Top five holdings by current value.
SELECT * FROM (SELECT s.symbol,h.quantity*lp.close_price market_value FROM holdings h JOIN stocks s ON s.stock_id=h.stock_id JOIN (SELECT stock_id,close_price,ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY price_date DESC) rn FROM historical_stock_prices) lp ON lp.stock_id=s.stock_id AND lp.rn=1 ORDER BY market_value DESC) WHERE ROWNUM<=5;
-- 07. Worst unrealised positions.
SELECT s.symbol,h.quantity*lp.close_price-h.cost_basis unrealized_pl FROM holdings h JOIN stocks s ON s.stock_id=h.stock_id JOIN (SELECT stock_id,close_price,ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY price_date DESC) rn FROM historical_stock_prices) lp ON lp.stock_id=s.stock_id AND lp.rn=1 ORDER BY unrealized_pl;
-- 08. All ledger transactions.
SELECT t.transaction_date,p.portfolio_name,s.symbol,t.transaction_type,t.quantity,t.execution_price,t.fees,t.realized_pl FROM portfolio_transaction t JOIN portfolios p ON p.portfolio_id=t.portfolio_id JOIN stocks s ON s.stock_id=t.stock_id ORDER BY t.transaction_date DESC;
-- 09. Transaction count and value by type.
SELECT transaction_type,COUNT(*) transaction_count,SUM(quantity*execution_price) gross_value FROM portfolio_transaction GROUP BY transaction_type;
-- 10. Realised P/L by portfolio.
SELECT p.portfolio_name,NVL(SUM(t.realized_pl),0) realised_pl FROM portfolios p LEFT JOIN portfolio_transaction t ON t.portfolio_id=p.portfolio_id GROUP BY p.portfolio_name;
-- 11. Watchlist entries with sector.
SELECT u.full_name,s.symbol,s.company_name,se.sector_name,w.added_at FROM watchlist w JOIN users u ON u.user_id=w.user_id JOIN stocks s ON s.stock_id=w.stock_id JOIN sectors se ON se.sector_id=s.sector_id;
-- 12. Stocks never traded.
SELECT s.symbol FROM stocks s WHERE NOT EXISTS (SELECT 1 FROM portfolio_transaction t WHERE t.stock_id=s.stock_id);
-- 13. Portfolios with no open holdings.
SELECT p.portfolio_name FROM portfolios p WHERE NOT EXISTS (SELECT 1 FROM holdings h WHERE h.portfolio_id=p.portfolio_id);
-- 14. Prices for one stock, newest first.
SELECT s.symbol,p.price_date,p.close_price FROM historical_stock_prices p JOIN stocks s ON s.stock_id=p.stock_id WHERE s.symbol='TCS' ORDER BY p.price_date DESC;
-- 15. Average stored price per stock.
SELECT s.symbol,ROUND(AVG(p.close_price),2) average_price FROM stocks s JOIN historical_stock_prices p ON p.stock_id=s.stock_id GROUP BY s.symbol;
-- 16. Sector allocation by current value.
SELECT se.sector_name,SUM(h.quantity*lp.close_price) sector_value FROM holdings h JOIN stocks s ON s.stock_id=h.stock_id JOIN sectors se ON se.sector_id=s.sector_id JOIN (SELECT stock_id,close_price,ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY price_date DESC) rn FROM historical_stock_prices) lp ON lp.stock_id=s.stock_id AND lp.rn=1 GROUP BY se.sector_name;
-- 17. Current value by portfolio.
SELECT p.portfolio_name,portfolio_market_value(p.portfolio_id) market_value FROM portfolios p;
-- 18. Portfolios above the average market value (subquery).
SELECT p.portfolio_name FROM portfolios p WHERE portfolio_market_value(p.portfolio_id) > (SELECT AVG(portfolio_market_value(portfolio_id)) FROM portfolios);
-- 19. Most frequently traded stock (correlated aggregate).
SELECT s.symbol FROM stocks s WHERE (SELECT COUNT(*) FROM portfolio_transaction t WHERE t.stock_id=s.stock_id) >= ALL (SELECT COUNT(*) FROM portfolio_transaction GROUP BY stock_id);
-- 20. Monthly ledger summary.
SELECT TO_CHAR(transaction_date,'YYYY-MM') trade_month,transaction_type,COUNT(*) trades,SUM(quantity*execution_price) gross_value FROM portfolio_transaction GROUP BY TO_CHAR(transaction_date,'YYYY-MM'),transaction_type ORDER BY trade_month;
-- 21. Holdings whose return is positive.
SELECT s.symbol,ROUND((h.quantity*lp.close_price-h.cost_basis)*100/NULLIF(h.cost_basis,0),2) return_pct FROM holdings h JOIN stocks s ON s.stock_id=h.stock_id JOIN (SELECT stock_id,close_price,ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY price_date DESC) rn FROM historical_stock_prices) lp ON lp.stock_id=s.stock_id AND lp.rn=1 WHERE h.quantity*lp.close_price>h.cost_basis;
-- 22. Audit trail inspection.
SELECT transaction_id,action_type,changed_at,changed_by FROM transaction_audit ORDER BY audit_id;
-- 23. Total fees by portfolio.
SELECT p.portfolio_name,SUM(t.fees) total_fees FROM portfolios p JOIN portfolio_transaction t ON t.portfolio_id=p.portfolio_id GROUP BY p.portfolio_name;
-- 24. Latest price date per sector.
SELECT se.sector_name,MAX(hp.price_date) latest_price_date FROM sectors se JOIN stocks s ON s.sector_id=se.sector_id JOIN historical_stock_prices hp ON hp.stock_id=s.stock_id GROUP BY se.sector_name;
-- 25. Integrity reconciliation: every open holding must agree with signed ledger quantity.
SELECT h.holding_id FROM holdings h WHERE h.quantity<>(SELECT SUM(CASE WHEN t.transaction_type='BUY' THEN t.quantity ELSE -t.quantity END) FROM portfolio_transaction t WHERE t.portfolio_id=h.portfolio_id AND t.stock_id=h.stock_id);
