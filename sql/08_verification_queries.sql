-- Run after 01–07. Expected failures are intentionally commented out.
PROMPT === Holding consistency ===
SELECT p.portfolio_name,s.symbol,h.quantity,h.average_cost,h.cost_basis
FROM holdings h JOIN portfolios p ON p.portfolio_id=h.portfolio_id JOIN stocks s ON s.stock_id=h.stock_id ORDER BY p.portfolio_name,s.symbol;
PROMPT === Function results ===
SELECT portfolio_id,portfolio_market_value(portfolio_id) market_value,portfolio_cost_basis(portfolio_id) cost_basis,portfolio_unrealized_pl(portfolio_id) unrealized_pl,portfolio_return_percentage(portfolio_id) return_pct FROM portfolios;
PROMPT === Audit entries ===
SELECT action_type,COUNT(*) audit_rows FROM transaction_audit GROUP BY action_type;
PROMPT === Duplicate-watchlist constraint test (must fail with ORA-00001) ===
-- INSERT INTO watchlist(user_id,stock_id) VALUES(1,1);
PROMPT === Oversell test (must fail with ORA-20004 and leave ledger unchanged) ===
-- BEGIN add_sell_transaction(1,1,999999,100,TRUNC(SYSDATE),0,'negative test'); END;
-- /
PROMPT === Reconcile holding quantity against ledger ===
SELECT h.portfolio_id,h.stock_id,h.quantity AS holding_quantity,
       SUM(CASE WHEN t.transaction_type='BUY' THEN t.quantity ELSE -t.quantity END) AS ledger_quantity
FROM holdings h JOIN portfolio_transaction t ON t.portfolio_id=h.portfolio_id AND t.stock_id=h.stock_id
GROUP BY h.portfolio_id,h.stock_id,h.quantity;
