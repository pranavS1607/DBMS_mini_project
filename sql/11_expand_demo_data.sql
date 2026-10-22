-- Portfolio Management Database System
-- 11_expand_demo_data.sql
-- Adds richer ILLUSTRATIVE NSE-style demo data to an already-seeded schema.
-- Does not drop tables or delete existing rows. Do NOT run 10_reset_demo_data.sql.
-- Prices and trades below are invented for classroom demonstration; NOT actual market data.
-- Intended for the existing seed from 07_seed_data.sql (user_id=1; two named portfolios).
-- Safe to rerun: master rows/prices are merged; transactions are guarded by unique notes.

SET SERVEROUTPUT ON;

-- Add sectors only when missing.
MERGE INTO sectors dst
USING (
  SELECT 'Financial Services' sector_name, 'Diversified financial services' description FROM dual UNION ALL
  SELECT 'Telecommunications', 'Telecommunications services' FROM dual UNION ALL
  SELECT 'Industrials', 'Engineering and infrastructure' FROM dual UNION ALL
  SELECT 'Healthcare', 'Pharmaceuticals and healthcare' FROM dual UNION ALL
  SELECT 'Automobiles', 'Automobile manufacturers' FROM dual
) src
ON (dst.sector_name = src.sector_name)
WHEN NOT MATCHED THEN
  INSERT (sector_name, description) VALUES (src.sector_name, src.description);

-- Add familiar Indian-listed companies. Sector IDs are looked up by name, not assumed.
MERGE INTO stocks dst
USING (
  SELECT 'ICICIBANK' symbol, 'ICICI Bank Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
  SELECT 'BHARTIARTL', 'Bharti Airtel Limited', 'Telecommunications' FROM dual UNION ALL
  SELECT 'LT', 'Larsen & Toubro Limited', 'Industrials' FROM dual UNION ALL
  SELECT 'SUNPHARMA', 'Sun Pharmaceutical Industries Limited', 'Healthcare' FROM dual UNION ALL
  SELECT 'MARUTI', 'Maruti Suzuki India Limited', 'Automobiles' FROM dual UNION ALL
  SELECT 'SBIN', 'State Bank of India', 'Banking' FROM dual UNION ALL
  SELECT 'WIPRO', 'Wipro Limited', 'Information Technology' FROM dual UNION ALL
  SELECT 'AXISBANK', 'Axis Bank Limited', 'Banking' FROM dual UNION ALL
  SELECT 'TATAMOTORS', 'Tata Motors Limited', 'Automobiles' FROM dual UNION ALL
  SELECT 'TITAN', 'Titan Company Limited', 'Consumer Goods' FROM dual
) src
ON (dst.symbol = src.symbol)
WHEN NOT MATCHED THEN
  INSERT (symbol, company_name, sector_id, exchange)
  VALUES (src.symbol, src.company_name,
          (SELECT sector_id FROM sectors WHERE sector_name = src.sector_name), 'NSE');

-- Three illustrative price points per stock. These are deliberately not presented as real quotes.
MERGE INTO historical_stock_prices dst
USING (
  SELECT s.stock_id, DATE '2026-09-01' price_date, p.price close_price FROM stocks s
  JOIN (SELECT 'TCS' symbol, 4020 price FROM dual UNION ALL SELECT 'INFY', 1460 FROM dual UNION ALL
        SELECT 'HDFCBANK', 1630 FROM dual UNION ALL SELECT 'RELIANCE', 1280 FROM dual UNION ALL
        SELECT 'ITC', 455 FROM dual UNION ALL SELECT 'ICICIBANK', 1190 FROM dual UNION ALL
        SELECT 'BHARTIARTL', 1880 FROM dual UNION ALL SELECT 'LT', 3540 FROM dual UNION ALL
        SELECT 'SUNPHARMA', 1690 FROM dual UNION ALL SELECT 'MARUTI', 12400 FROM dual UNION ALL
        SELECT 'SBIN', 790 FROM dual UNION ALL SELECT 'WIPRO', 525 FROM dual UNION ALL
        SELECT 'AXISBANK', 1120 FROM dual UNION ALL SELECT 'TATAMOTORS', 680 FROM dual UNION ALL
        SELECT 'TITAN', 3650 FROM dual) p ON p.symbol = s.symbol
  UNION ALL
  SELECT s.stock_id, DATE '2026-10-01', p.price FROM stocks s
  JOIN (SELECT 'TCS' symbol, 4180 price FROM dual UNION ALL SELECT 'INFY', 1505 FROM dual UNION ALL
        SELECT 'HDFCBANK', 1685 FROM dual UNION ALL SELECT 'RELIANCE', 1345 FROM dual UNION ALL
        SELECT 'ITC', 470 FROM dual UNION ALL SELECT 'ICICIBANK', 1235 FROM dual UNION ALL
        SELECT 'BHARTIARTL', 1940 FROM dual UNION ALL SELECT 'LT', 3660 FROM dual UNION ALL
        SELECT 'SUNPHARMA', 1735 FROM dual UNION ALL SELECT 'MARUTI', 12750 FROM dual UNION ALL
        SELECT 'SBIN', 815 FROM dual UNION ALL SELECT 'WIPRO', 510 FROM dual UNION ALL
        SELECT 'AXISBANK', 1160 FROM dual UNION ALL SELECT 'TATAMOTORS', 705 FROM dual UNION ALL
        SELECT 'TITAN', 3720 FROM dual) p ON p.symbol = s.symbol
  UNION ALL
  SELECT s.stock_id, DATE '2026-10-20', p.price FROM stocks s
  JOIN (SELECT 'TCS' symbol, 4275 price FROM dual UNION ALL SELECT 'INFY', 1570 FROM dual UNION ALL
        SELECT 'HDFCBANK', 1712 FROM dual UNION ALL SELECT 'RELIANCE', 1390 FROM dual UNION ALL
        SELECT 'ITC', 485 FROM dual UNION ALL SELECT 'ICICIBANK', 1288 FROM dual UNION ALL
        SELECT 'BHARTIARTL', 2015 FROM dual UNION ALL SELECT 'LT', 3795 FROM dual UNION ALL
        SELECT 'SUNPHARMA', 1780 FROM dual UNION ALL SELECT 'MARUTI', 13120 FROM dual UNION ALL
        SELECT 'SBIN', 842 FROM dual UNION ALL SELECT 'WIPRO', 498 FROM dual UNION ALL
        SELECT 'AXISBANK', 1195 FROM dual UNION ALL SELECT 'TATAMOTORS', 735 FROM dual UNION ALL
        SELECT 'TITAN', 3890 FROM dual) p ON p.symbol = s.symbol
) src
ON (dst.stock_id = src.stock_id AND dst.price_date = src.price_date)
WHEN MATCHED THEN UPDATE SET dst.close_price = src.close_price, dst.source_label = 'ILLUSTRATIVE CLASS DEMO'
WHEN NOT MATCHED THEN
  INSERT (stock_id, price_date, close_price, source_label)
  VALUES (src.stock_id, src.price_date, src.close_price, 'ILLUSTRATIVE CLASS DEMO');

-- Append transactions through the existing PL/SQL procedures so holdings remain reconciled.
-- Guard each transaction by its distinctive note so this script can be rerun safely.
DECLARE
  v_portfolio_id portfolios.portfolio_id%TYPE;
  v_stock_id stocks.stock_id%TYPE;
  v_count PLS_INTEGER;
BEGIN
  SELECT portfolio_id INTO v_portfolio_id FROM portfolios WHERE user_id=1 AND portfolio_name='Long Term Growth';

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='ICICIBANK';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: ICICI Bank initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,18,1210,DATE '2026-09-08',18,'Demo expansion: ICICI Bank initial buy');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='BHARTIARTL';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: Airtel initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,12,1900,DATE '2026-09-10',15,'Demo expansion: Airtel initial buy');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='LT';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: L&T initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,8,3600,DATE '2026-09-12',20,'Demo expansion: L&T initial buy');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='SUNPHARMA';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: Sun Pharma initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,10,1710,DATE '2026-09-15',12,'Demo expansion: Sun Pharma initial buy');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='ICICIBANK';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: ICICI Bank partial sale';
  IF v_count=0 THEN
    add_sell_transaction(v_portfolio_id,v_stock_id,4,1260,DATE '2026-10-05',8,'Demo expansion: ICICI Bank partial sale');
  END IF;

  SELECT portfolio_id INTO v_portfolio_id FROM portfolios WHERE user_id=1 AND portfolio_name='Income & Stability';

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='SBIN';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: SBI initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,25,805,DATE '2026-09-09',15,'Demo expansion: SBI initial buy');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='AXISBANK';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: Axis Bank initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,14,1140,DATE '2026-09-11',14,'Demo expansion: Axis Bank initial buy');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='MARUTI';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: Maruti initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,3,12600,DATE '2026-09-14',18,'Demo expansion: Maruti initial buy');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='WIPRO';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: Wipro initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,20,520,DATE '2026-09-17',10,'Demo expansion: Wipro initial buy');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='SBIN';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: SBI partial sale';
  IF v_count=0 THEN
    add_sell_transaction(v_portfolio_id,v_stock_id,5,830,DATE '2026-10-08',8,'Demo expansion: SBI partial sale');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='TATAMOTORS';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: Tata Motors initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,16,700,DATE '2026-09-20',16,'Demo expansion: Tata Motors initial buy');
  END IF;

  SELECT stock_id INTO v_stock_id FROM stocks WHERE symbol='TITAN';
  SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE portfolio_id=v_portfolio_id AND stock_id=v_stock_id AND notes='Demo expansion: Titan initial buy';
  IF v_count=0 THEN
    add_buy_transaction(v_portfolio_id,v_stock_id,6,3700,DATE '2026-09-22',12,'Demo expansion: Titan initial buy');
  END IF;

  COMMIT;
END;
/

-- Add a few more watchlist names without duplicating existing entries.
INSERT INTO watchlist(user_id, stock_id)
SELECT 1, s.stock_id FROM stocks s
WHERE s.symbol IN ('ICICIBANK','BHARTIARTL','LT','SUNPHARMA','SBIN','TITAN')
  AND NOT EXISTS (SELECT 1 FROM watchlist w WHERE w.user_id=1 AND w.stock_id=s.stock_id);

COMMIT;

PROMPT === Demo expansion complete ===
PROMPT Reminder: all values are illustrative and are not actual NSE historical prices.
PROMPT Run @sql/08_verification_queries.sql to check holdings and portfolio metrics.
PROMPT Run @sql/09_demo_queries.sql to explore the expanded dataset.
