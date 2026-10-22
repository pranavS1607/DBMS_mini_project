CREATE OR REPLACE PROCEDURE create_portfolio(
  p_user_id IN NUMBER, p_name IN VARCHAR2, p_description IN VARCHAR2, p_portfolio_id OUT NUMBER
) AS
BEGIN
  IF TRIM(p_name) IS NULL OR LENGTH(TRIM(p_name)) > 100 THEN RAISE_APPLICATION_ERROR(-20001,'A portfolio name of 1–100 characters is required.'); END IF;
  INSERT INTO portfolios(user_id,portfolio_name,description) VALUES(p_user_id,TRIM(p_name),TRIM(p_description)) RETURNING portfolio_id INTO p_portfolio_id;
END;
/
CREATE OR REPLACE PROCEDURE add_buy_transaction(
  p_portfolio_id IN NUMBER,p_stock_id IN NUMBER,p_quantity IN NUMBER,p_price IN NUMBER,
  p_date IN DATE,p_fees IN NUMBER DEFAULT 0,p_notes IN VARCHAR2 DEFAULT NULL
) AS
  v_quantity holdings.quantity%TYPE; v_basis holdings.cost_basis%TYPE; v_new_basis NUMBER(18,4);
BEGIN
  IF p_quantity <= 0 OR p_price <= 0 OR NVL(p_fees,0) < 0 OR p_date IS NULL THEN RAISE_APPLICATION_ERROR(-20002,'Quantity, price and date must be valid; fees cannot be negative.'); END IF;
  BEGIN SELECT quantity,cost_basis INTO v_quantity,v_basis FROM holdings WHERE portfolio_id=p_portfolio_id AND stock_id=p_stock_id FOR UPDATE;
    v_new_basis := v_basis + p_quantity*p_price + NVL(p_fees,0);
    UPDATE holdings SET quantity=v_quantity+p_quantity,cost_basis=v_new_basis,average_cost=v_new_basis/(v_quantity+p_quantity),updated_at=SYSTIMESTAMP WHERE portfolio_id=p_portfolio_id AND stock_id=p_stock_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    INSERT INTO holdings(portfolio_id,stock_id,quantity,average_cost,cost_basis) VALUES(p_portfolio_id,p_stock_id,p_quantity,(p_quantity*p_price+NVL(p_fees,0))/p_quantity,p_quantity*p_price+NVL(p_fees,0));
  END;
  INSERT INTO portfolio_transaction(portfolio_id,stock_id,transaction_type,quantity,execution_price,transaction_date,fees,notes) VALUES(p_portfolio_id,p_stock_id,'BUY',p_quantity,p_price,p_date,NVL(p_fees,0),p_notes);
END;
/
CREATE OR REPLACE PROCEDURE add_sell_transaction(
  p_portfolio_id IN NUMBER,p_stock_id IN NUMBER,p_quantity IN NUMBER,p_price IN NUMBER,
  p_date IN DATE,p_fees IN NUMBER DEFAULT 0,p_notes IN VARCHAR2 DEFAULT NULL
) AS
  v_quantity holdings.quantity%TYPE; v_average holdings.average_cost%TYPE; v_new_quantity NUMBER(18,4); v_realized NUMBER(18,4);
BEGIN
  IF p_quantity <= 0 OR p_price <= 0 OR NVL(p_fees,0) < 0 OR p_date IS NULL THEN RAISE_APPLICATION_ERROR(-20003,'Quantity, price and date must be valid; fees cannot be negative.'); END IF;
  SELECT quantity,average_cost INTO v_quantity,v_average FROM holdings WHERE portfolio_id=p_portfolio_id AND stock_id=p_stock_id FOR UPDATE;
  IF p_quantity > v_quantity THEN RAISE_APPLICATION_ERROR(-20004,'Sell rejected: requested quantity exceeds the available holding.'); END IF;
  v_new_quantity:=v_quantity-p_quantity; v_realized:=p_quantity*p_price-NVL(p_fees,0)-p_quantity*v_average;
  IF v_new_quantity=0 THEN DELETE FROM holdings WHERE portfolio_id=p_portfolio_id AND stock_id=p_stock_id;
  ELSE UPDATE holdings SET quantity=v_new_quantity,cost_basis=v_new_quantity*v_average,updated_at=SYSTIMESTAMP WHERE portfolio_id=p_portfolio_id AND stock_id=p_stock_id; END IF;
  INSERT INTO portfolio_transaction(portfolio_id,stock_id,transaction_type,quantity,execution_price,transaction_date,fees,notes,realized_pl) VALUES(p_portfolio_id,p_stock_id,'SELL',p_quantity,p_price,p_date,NVL(p_fees,0),p_notes,v_realized);
EXCEPTION WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20005,'Sell rejected: no holding exists for this stock and portfolio.');
END;
/
