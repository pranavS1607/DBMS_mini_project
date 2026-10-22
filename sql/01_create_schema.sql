-- Portfolio Management Database System: base Oracle 19c+/23ai schema.
-- Run from SQL*Plus as the application schema owner.

CREATE TABLE users (
  user_id NUMBER GENERATED ALWAYS AS IDENTITY, full_name VARCHAR2(120) NOT NULL,
  email VARCHAR2(180) NOT NULL, created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);
CREATE TABLE sectors (
  sector_id NUMBER GENERATED ALWAYS AS IDENTITY, sector_name VARCHAR2(80) NOT NULL, description VARCHAR2(240)
);
CREATE TABLE stocks (
  stock_id NUMBER GENERATED ALWAYS AS IDENTITY, symbol VARCHAR2(20) NOT NULL,
  company_name VARCHAR2(160) NOT NULL, sector_id NUMBER NOT NULL, exchange VARCHAR2(30) DEFAULT 'NSE' NOT NULL,
  active_flag CHAR(1) DEFAULT 'Y' NOT NULL, created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);
CREATE TABLE portfolios (
  portfolio_id NUMBER GENERATED ALWAYS AS IDENTITY, user_id NUMBER NOT NULL,
  portfolio_name VARCHAR2(100) NOT NULL, description VARCHAR2(300), created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);
CREATE TABLE historical_stock_prices (
  price_id NUMBER GENERATED ALWAYS AS IDENTITY, stock_id NUMBER NOT NULL, price_date DATE NOT NULL,
  close_price NUMBER(15,4) NOT NULL, source_label VARCHAR2(80) DEFAULT 'DEMONSTRATION SEED' NOT NULL,
  created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);
CREATE TABLE portfolio_transaction (
  transaction_id NUMBER GENERATED ALWAYS AS IDENTITY, portfolio_id NUMBER NOT NULL, stock_id NUMBER NOT NULL,
  transaction_type VARCHAR2(4) NOT NULL, quantity NUMBER(18,4) NOT NULL, execution_price NUMBER(15,4) NOT NULL,
  transaction_date DATE NOT NULL, fees NUMBER(15,4) DEFAULT 0 NOT NULL, notes VARCHAR2(500),
  realized_pl NUMBER(18,4), created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);
-- Current open position. Zero-quantity rows are removed by ADD_SELL_TRANSACTION.
CREATE TABLE holdings (
  holding_id NUMBER GENERATED ALWAYS AS IDENTITY, portfolio_id NUMBER NOT NULL, stock_id NUMBER NOT NULL,
  quantity NUMBER(18,4) NOT NULL, average_cost NUMBER(15,4) NOT NULL, cost_basis NUMBER(18,4) NOT NULL,
  updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);
CREATE TABLE watchlist (
  watchlist_id NUMBER GENERATED ALWAYS AS IDENTITY, user_id NUMBER NOT NULL, stock_id NUMBER NOT NULL,
  added_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);
