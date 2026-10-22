-- Demonstration data only. Seed prices are NOT real-time quotes.
INSERT INTO users(full_name,email) VALUES('Pranav Suryadevara','pranav.demo@example.edu');
INSERT INTO sectors(sector_name,description) VALUES('Information Technology','Software and technology services');
INSERT INTO sectors(sector_name,description) VALUES('Banking','Private-sector banking');
INSERT INTO sectors(sector_name,description) VALUES('Energy','Oil and gas');
INSERT INTO sectors(sector_name,description) VALUES('Consumer Goods','Consumer staples');
INSERT INTO stocks(symbol,company_name,sector_id,exchange) VALUES('TCS','Tata Consultancy Services',1,'NSE');
INSERT INTO stocks(symbol,company_name,sector_id,exchange) VALUES('INFY','Infosys Limited',1,'NSE');
INSERT INTO stocks(symbol,company_name,sector_id,exchange) VALUES('HDFCBANK','HDFC Bank Limited',2,'NSE');
INSERT INTO stocks(symbol,company_name,sector_id,exchange) VALUES('RELIANCE','Reliance Industries Limited',3,'NSE');
INSERT INTO stocks(symbol,company_name,sector_id,exchange) VALUES('ITC','ITC Limited',4,'NSE');
INSERT INTO portfolios(user_id,portfolio_name,description) VALUES(1,'Long Term Growth','Core equity holdings for the lab demo');
INSERT INTO portfolios(user_id,portfolio_name,description) VALUES(1,'Income & Stability','Diversified secondary portfolio');
INSERT INTO historical_stock_prices(stock_id,price_date,close_price,source_label) VALUES(1,DATE '2026-10-01',4180,'DEMONSTRATION SEED');
INSERT INTO historical_stock_prices(stock_id,price_date,close_price,source_label) VALUES(1,DATE '2026-10-20',4275,'DEMONSTRATION SEED');
INSERT INTO historical_stock_prices(stock_id,price_date,close_price,source_label) VALUES(2,DATE '2026-10-01',1505,'DEMONSTRATION SEED');
INSERT INTO historical_stock_prices(stock_id,price_date,close_price,source_label) VALUES(2,DATE '2026-10-20',1570,'DEMONSTRATION SEED');
INSERT INTO historical_stock_prices(stock_id,price_date,close_price,source_label) VALUES(3,DATE '2026-10-20',1712,'DEMONSTRATION SEED');
INSERT INTO historical_stock_prices(stock_id,price_date,close_price,source_label) VALUES(4,DATE '2026-10-20',1390,'DEMONSTRATION SEED');
INSERT INTO historical_stock_prices(stock_id,price_date,close_price,source_label) VALUES(5,DATE '2026-10-20',485,'DEMONSTRATION SEED');
BEGIN
  add_buy_transaction(1,1,10,4100,DATE '2026-10-02',20,'Initial TCS purchase');
  add_buy_transaction(1,3,25,1650,DATE '2026-10-03',25,'Initial bank allocation');
  add_buy_transaction(1,4,20,1320,DATE '2026-10-04',20,'Energy allocation');
  add_sell_transaction(1,1,2,4200,DATE '2026-10-10',10,'Partial profit booking');
  add_buy_transaction(2,2,30,1480,DATE '2026-10-05',30,'IT allocation');
  add_buy_transaction(2,5,40,470,DATE '2026-10-06',20,'Consumer allocation');
END;
/
INSERT INTO watchlist(user_id,stock_id) VALUES(1,1);
INSERT INTO watchlist(user_id,stock_id) VALUES(1,4);
COMMIT;
