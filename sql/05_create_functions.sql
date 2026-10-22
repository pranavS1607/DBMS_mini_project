CREATE OR REPLACE FUNCTION portfolio_cost_basis(p_portfolio_id NUMBER) RETURN NUMBER AS v_value NUMBER;
BEGIN SELECT NVL(SUM(cost_basis),0) INTO v_value FROM holdings WHERE portfolio_id=p_portfolio_id; RETURN v_value; END;
/
CREATE OR REPLACE FUNCTION portfolio_market_value(p_portfolio_id NUMBER) RETURN NUMBER AS v_value NUMBER;
BEGIN SELECT NVL(SUM(h.quantity*(SELECT p.close_price FROM historical_stock_prices p WHERE p.stock_id=h.stock_id ORDER BY p.price_date DESC FETCH FIRST 1 ROW ONLY)),0) INTO v_value FROM holdings h WHERE h.portfolio_id=p_portfolio_id; RETURN v_value; END;
/
CREATE OR REPLACE FUNCTION portfolio_unrealized_pl(p_portfolio_id NUMBER) RETURN NUMBER AS
BEGIN RETURN portfolio_market_value(p_portfolio_id)-portfolio_cost_basis(p_portfolio_id); END;
/
CREATE OR REPLACE FUNCTION portfolio_return_percentage(p_portfolio_id NUMBER) RETURN NUMBER AS v_cost NUMBER;
BEGIN v_cost:=portfolio_cost_basis(p_portfolio_id); IF v_cost=0 THEN RETURN 0; END IF; RETURN ROUND(portfolio_unrealized_pl(p_portfolio_id)*100/v_cost,2); END;
/
