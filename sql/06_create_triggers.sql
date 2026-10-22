-- Audits any attempted ledger maintenance by a privileged correction process.
CREATE OR REPLACE TRIGGER trg_transaction_audit
AFTER INSERT OR UPDATE OR DELETE ON portfolio_transaction FOR EACH ROW
BEGIN
  IF INSERTING THEN INSERT INTO transaction_audit(transaction_id,action_type,new_quantity,new_price) VALUES(:NEW.transaction_id,'INSERT',:NEW.quantity,:NEW.execution_price);
  ELSIF UPDATING THEN INSERT INTO transaction_audit(transaction_id,action_type,old_quantity,new_quantity,old_price,new_price) VALUES(:NEW.transaction_id,'UPDATE',:OLD.quantity,:NEW.quantity,:OLD.execution_price,:NEW.execution_price);
  ELSE INSERT INTO transaction_audit(transaction_id,action_type,old_quantity,old_price) VALUES(:OLD.transaction_id,'DELETE',:OLD.quantity,:OLD.execution_price); END IF;
END;
/
-- Declarative checks stop negative prices; this gives a useful date-specific integrity error.
CREATE OR REPLACE TRIGGER trg_price_date_guard
BEFORE INSERT OR UPDATE OF price_date ON historical_stock_prices FOR EACH ROW
BEGIN
  IF :NEW.price_date > TRUNC(SYSDATE)+1 THEN RAISE_APPLICATION_ERROR(-20006,'A historical price date cannot be more than one day in the future.'); END IF;
END;
/
