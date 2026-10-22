CREATE TABLE transaction_audit (
  audit_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, transaction_id NUMBER,
  action_type VARCHAR2(10) NOT NULL, old_quantity NUMBER(18,4), new_quantity NUMBER(18,4),
  old_price NUMBER(15,4), new_price NUMBER(15,4), changed_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  changed_by VARCHAR2(128) DEFAULT USER NOT NULL
);
CREATE INDEX ix_transaction_audit_tx ON transaction_audit(transaction_id);
