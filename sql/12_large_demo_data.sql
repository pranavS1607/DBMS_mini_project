-- Portfolio Management Database System: large synthetic demo data expansion
-- Adds 135 synthetic stocks (target total 150), 100 price observations per stock (~15,000),
-- 500 transactions via existing procedures, extra portfolios and watchlist entries.
-- Prices and synthetic stock names are for classroom demonstration only; NOT real NSE data.
-- Safe to rerun: stocks/sectors/prices/portfolios/watchlist merge or existence-check; transactions use unique notes.
-- Run from SQL*Plus as PORTFOLIO_APP. Do NOT run 10_reset_demo_data.sql.
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- 1) Add any missing sectors.
MERGE INTO sectors d USING (SELECT 'Banking' sector_name, 'Banks and financial institutions' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Information Technology' sector_name, 'Software and IT services' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Consumer Goods' sector_name, 'Consumer products and retail' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Energy' sector_name, 'Energy and utilities' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Telecommunications' sector_name, 'Telecommunications services' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Industrials' sector_name, 'Engineering and infrastructure' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Healthcare' sector_name, 'Pharmaceuticals and healthcare' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Automobiles' sector_name, 'Automobile manufacturers' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Financial Services' sector_name, 'Diversified financial services' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Materials' sector_name, 'Metals, chemicals and materials' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Real Estate' sector_name, 'Property and real estate' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Utilities' sector_name, 'Power and utility services' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Consumer Services' sector_name, 'Consumer and business services' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Transport' sector_name, 'Transport and logistics' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);
MERGE INTO sectors d USING (SELECT 'Media' sector_name, 'Media and entertainment' description FROM dual) s ON (d.sector_name=s.sector_name) WHEN NOT MATCHED THEN INSERT (sector_name,description) VALUES (s.sector_name,s.description);

-- 2) Add 135 extra synthetic instruments. Existing 15 seeded stocks are untouched.
MERGE INTO stocks d USING (
SELECT 'DMS016' symbol, 'Demo Industrials 016 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS017' symbol, 'Demo Consumer 017 Limited' company_name, 'Consumer Goods' sector_name FROM dual UNION ALL
SELECT 'DMS018' symbol, 'Demo Healthcare 018 Limited' company_name, 'Healthcare' sector_name FROM dual UNION ALL
SELECT 'DMS019' symbol, 'Demo Energy 019 Limited' company_name, 'Energy' sector_name FROM dual UNION ALL
SELECT 'DMS020' symbol, 'Demo Banking 020 Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
SELECT 'DMS021' symbol, 'Demo Technology 021 Limited' company_name, 'Information Technology' sector_name FROM dual UNION ALL
SELECT 'DMS022' symbol, 'Demo Materials 022 Limited' company_name, 'Materials' sector_name FROM dual UNION ALL
SELECT 'DMS023' symbol, 'Demo Auto 023 Limited' company_name, 'Automobiles' sector_name FROM dual UNION ALL
SELECT 'DMS024' symbol, 'Demo Utilities 024 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS025' symbol, 'Demo Finance 025 Limited' company_name, 'Financial Services' sector_name FROM dual UNION ALL
SELECT 'DMS026' symbol, 'Synthetic Industrials Company 026 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS027' symbol, 'Synthetic Consumer Services Company 027 Limited' company_name, 'Consumer Services' sector_name FROM dual UNION ALL
SELECT 'DMS028' symbol, 'Synthetic Telecommunications Company 028 Limited' company_name, 'Telecommunications' sector_name FROM dual UNION ALL
SELECT 'DMS029' symbol, 'Synthetic Utilities Company 029 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS030' symbol, 'Synthetic Energy Company 030 Limited' company_name, 'Energy' sector_name FROM dual UNION ALL
SELECT 'DMS031' symbol, 'Synthetic Real Estate Company 031 Limited' company_name, 'Real Estate' sector_name FROM dual UNION ALL
SELECT 'DMS032' symbol, 'Synthetic Consumer Goods Company 032 Limited' company_name, 'Consumer Goods' sector_name FROM dual UNION ALL
SELECT 'DMS033' symbol, 'Synthetic Materials Company 033 Limited' company_name, 'Materials' sector_name FROM dual UNION ALL
SELECT 'DMS034' symbol, 'Synthetic Information Technology Company 034 Limited' company_name, 'Information Technology' sector_name FROM dual UNION ALL
SELECT 'DMS035' symbol, 'Synthetic Financial Services Company 035 Limited' company_name, 'Financial Services' sector_name FROM dual UNION ALL
SELECT 'DMS036' symbol, 'Synthetic Banking Company 036 Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
SELECT 'DMS037' symbol, 'Synthetic Automobiles Company 037 Limited' company_name, 'Automobiles' sector_name FROM dual UNION ALL
SELECT 'DMS038' symbol, 'Synthetic Media Company 038 Limited' company_name, 'Media' sector_name FROM dual UNION ALL
SELECT 'DMS039' symbol, 'Synthetic Healthcare Company 039 Limited' company_name, 'Healthcare' sector_name FROM dual UNION ALL
SELECT 'DMS040' symbol, 'Synthetic Transport Company 040 Limited' company_name, 'Transport' sector_name FROM dual UNION ALL
SELECT 'DMS041' symbol, 'Synthetic Industrials Company 041 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS042' symbol, 'Synthetic Consumer Services Company 042 Limited' company_name, 'Consumer Services' sector_name FROM dual UNION ALL
SELECT 'DMS043' symbol, 'Synthetic Telecommunications Company 043 Limited' company_name, 'Telecommunications' sector_name FROM dual UNION ALL
SELECT 'DMS044' symbol, 'Synthetic Utilities Company 044 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS045' symbol, 'Synthetic Energy Company 045 Limited' company_name, 'Energy' sector_name FROM dual UNION ALL
SELECT 'DMS046' symbol, 'Synthetic Real Estate Company 046 Limited' company_name, 'Real Estate' sector_name FROM dual UNION ALL
SELECT 'DMS047' symbol, 'Synthetic Consumer Goods Company 047 Limited' company_name, 'Consumer Goods' sector_name FROM dual UNION ALL
SELECT 'DMS048' symbol, 'Synthetic Materials Company 048 Limited' company_name, 'Materials' sector_name FROM dual UNION ALL
SELECT 'DMS049' symbol, 'Synthetic Information Technology Company 049 Limited' company_name, 'Information Technology' sector_name FROM dual UNION ALL
SELECT 'DMS050' symbol, 'Synthetic Financial Services Company 050 Limited' company_name, 'Financial Services' sector_name FROM dual UNION ALL
SELECT 'DMS051' symbol, 'Synthetic Banking Company 051 Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
SELECT 'DMS052' symbol, 'Synthetic Automobiles Company 052 Limited' company_name, 'Automobiles' sector_name FROM dual UNION ALL
SELECT 'DMS053' symbol, 'Synthetic Media Company 053 Limited' company_name, 'Media' sector_name FROM dual UNION ALL
SELECT 'DMS054' symbol, 'Synthetic Healthcare Company 054 Limited' company_name, 'Healthcare' sector_name FROM dual UNION ALL
SELECT 'DMS055' symbol, 'Synthetic Transport Company 055 Limited' company_name, 'Transport' sector_name FROM dual UNION ALL
SELECT 'DMS056' symbol, 'Synthetic Industrials Company 056 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS057' symbol, 'Synthetic Consumer Services Company 057 Limited' company_name, 'Consumer Services' sector_name FROM dual UNION ALL
SELECT 'DMS058' symbol, 'Synthetic Telecommunications Company 058 Limited' company_name, 'Telecommunications' sector_name FROM dual UNION ALL
SELECT 'DMS059' symbol, 'Synthetic Utilities Company 059 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS060' symbol, 'Synthetic Energy Company 060 Limited' company_name, 'Energy' sector_name FROM dual UNION ALL
SELECT 'DMS061' symbol, 'Synthetic Real Estate Company 061 Limited' company_name, 'Real Estate' sector_name FROM dual UNION ALL
SELECT 'DMS062' symbol, 'Synthetic Consumer Goods Company 062 Limited' company_name, 'Consumer Goods' sector_name FROM dual UNION ALL
SELECT 'DMS063' symbol, 'Synthetic Materials Company 063 Limited' company_name, 'Materials' sector_name FROM dual UNION ALL
SELECT 'DMS064' symbol, 'Synthetic Information Technology Company 064 Limited' company_name, 'Information Technology' sector_name FROM dual UNION ALL
SELECT 'DMS065' symbol, 'Synthetic Financial Services Company 065 Limited' company_name, 'Financial Services' sector_name FROM dual UNION ALL
SELECT 'DMS066' symbol, 'Synthetic Banking Company 066 Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
SELECT 'DMS067' symbol, 'Synthetic Automobiles Company 067 Limited' company_name, 'Automobiles' sector_name FROM dual UNION ALL
SELECT 'DMS068' symbol, 'Synthetic Media Company 068 Limited' company_name, 'Media' sector_name FROM dual UNION ALL
SELECT 'DMS069' symbol, 'Synthetic Healthcare Company 069 Limited' company_name, 'Healthcare' sector_name FROM dual UNION ALL
SELECT 'DMS070' symbol, 'Synthetic Transport Company 070 Limited' company_name, 'Transport' sector_name FROM dual UNION ALL
SELECT 'DMS071' symbol, 'Synthetic Industrials Company 071 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS072' symbol, 'Synthetic Consumer Services Company 072 Limited' company_name, 'Consumer Services' sector_name FROM dual UNION ALL
SELECT 'DMS073' symbol, 'Synthetic Telecommunications Company 073 Limited' company_name, 'Telecommunications' sector_name FROM dual UNION ALL
SELECT 'DMS074' symbol, 'Synthetic Utilities Company 074 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS075' symbol, 'Synthetic Energy Company 075 Limited' company_name, 'Energy' sector_name FROM dual UNION ALL
SELECT 'DMS076' symbol, 'Synthetic Real Estate Company 076 Limited' company_name, 'Real Estate' sector_name FROM dual UNION ALL
SELECT 'DMS077' symbol, 'Synthetic Consumer Goods Company 077 Limited' company_name, 'Consumer Goods' sector_name FROM dual UNION ALL
SELECT 'DMS078' symbol, 'Synthetic Materials Company 078 Limited' company_name, 'Materials' sector_name FROM dual UNION ALL
SELECT 'DMS079' symbol, 'Synthetic Information Technology Company 079 Limited' company_name, 'Information Technology' sector_name FROM dual UNION ALL
SELECT 'DMS080' symbol, 'Synthetic Financial Services Company 080 Limited' company_name, 'Financial Services' sector_name FROM dual UNION ALL
SELECT 'DMS081' symbol, 'Synthetic Banking Company 081 Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
SELECT 'DMS082' symbol, 'Synthetic Automobiles Company 082 Limited' company_name, 'Automobiles' sector_name FROM dual UNION ALL
SELECT 'DMS083' symbol, 'Synthetic Media Company 083 Limited' company_name, 'Media' sector_name FROM dual UNION ALL
SELECT 'DMS084' symbol, 'Synthetic Healthcare Company 084 Limited' company_name, 'Healthcare' sector_name FROM dual UNION ALL
SELECT 'DMS085' symbol, 'Synthetic Transport Company 085 Limited' company_name, 'Transport' sector_name FROM dual UNION ALL
SELECT 'DMS086' symbol, 'Synthetic Industrials Company 086 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS087' symbol, 'Synthetic Consumer Services Company 087 Limited' company_name, 'Consumer Services' sector_name FROM dual UNION ALL
SELECT 'DMS088' symbol, 'Synthetic Telecommunications Company 088 Limited' company_name, 'Telecommunications' sector_name FROM dual UNION ALL
SELECT 'DMS089' symbol, 'Synthetic Utilities Company 089 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS090' symbol, 'Synthetic Energy Company 090 Limited' company_name, 'Energy' sector_name FROM dual UNION ALL
SELECT 'DMS091' symbol, 'Synthetic Real Estate Company 091 Limited' company_name, 'Real Estate' sector_name FROM dual UNION ALL
SELECT 'DMS092' symbol, 'Synthetic Consumer Goods Company 092 Limited' company_name, 'Consumer Goods' sector_name FROM dual UNION ALL
SELECT 'DMS093' symbol, 'Synthetic Materials Company 093 Limited' company_name, 'Materials' sector_name FROM dual UNION ALL
SELECT 'DMS094' symbol, 'Synthetic Information Technology Company 094 Limited' company_name, 'Information Technology' sector_name FROM dual UNION ALL
SELECT 'DMS095' symbol, 'Synthetic Financial Services Company 095 Limited' company_name, 'Financial Services' sector_name FROM dual UNION ALL
SELECT 'DMS096' symbol, 'Synthetic Banking Company 096 Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
SELECT 'DMS097' symbol, 'Synthetic Automobiles Company 097 Limited' company_name, 'Automobiles' sector_name FROM dual UNION ALL
SELECT 'DMS098' symbol, 'Synthetic Media Company 098 Limited' company_name, 'Media' sector_name FROM dual UNION ALL
SELECT 'DMS099' symbol, 'Synthetic Healthcare Company 099 Limited' company_name, 'Healthcare' sector_name FROM dual UNION ALL
SELECT 'DMS100' symbol, 'Synthetic Transport Company 100 Limited' company_name, 'Transport' sector_name FROM dual UNION ALL
SELECT 'DMS101' symbol, 'Synthetic Industrials Company 101 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS102' symbol, 'Synthetic Consumer Services Company 102 Limited' company_name, 'Consumer Services' sector_name FROM dual UNION ALL
SELECT 'DMS103' symbol, 'Synthetic Telecommunications Company 103 Limited' company_name, 'Telecommunications' sector_name FROM dual UNION ALL
SELECT 'DMS104' symbol, 'Synthetic Utilities Company 104 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS105' symbol, 'Synthetic Energy Company 105 Limited' company_name, 'Energy' sector_name FROM dual UNION ALL
SELECT 'DMS106' symbol, 'Synthetic Real Estate Company 106 Limited' company_name, 'Real Estate' sector_name FROM dual UNION ALL
SELECT 'DMS107' symbol, 'Synthetic Consumer Goods Company 107 Limited' company_name, 'Consumer Goods' sector_name FROM dual UNION ALL
SELECT 'DMS108' symbol, 'Synthetic Materials Company 108 Limited' company_name, 'Materials' sector_name FROM dual UNION ALL
SELECT 'DMS109' symbol, 'Synthetic Information Technology Company 109 Limited' company_name, 'Information Technology' sector_name FROM dual UNION ALL
SELECT 'DMS110' symbol, 'Synthetic Financial Services Company 110 Limited' company_name, 'Financial Services' sector_name FROM dual UNION ALL
SELECT 'DMS111' symbol, 'Synthetic Banking Company 111 Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
SELECT 'DMS112' symbol, 'Synthetic Automobiles Company 112 Limited' company_name, 'Automobiles' sector_name FROM dual UNION ALL
SELECT 'DMS113' symbol, 'Synthetic Media Company 113 Limited' company_name, 'Media' sector_name FROM dual UNION ALL
SELECT 'DMS114' symbol, 'Synthetic Healthcare Company 114 Limited' company_name, 'Healthcare' sector_name FROM dual UNION ALL
SELECT 'DMS115' symbol, 'Synthetic Transport Company 115 Limited' company_name, 'Transport' sector_name FROM dual UNION ALL
SELECT 'DMS116' symbol, 'Synthetic Industrials Company 116 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS117' symbol, 'Synthetic Consumer Services Company 117 Limited' company_name, 'Consumer Services' sector_name FROM dual UNION ALL
SELECT 'DMS118' symbol, 'Synthetic Telecommunications Company 118 Limited' company_name, 'Telecommunications' sector_name FROM dual UNION ALL
SELECT 'DMS119' symbol, 'Synthetic Utilities Company 119 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS120' symbol, 'Synthetic Energy Company 120 Limited' company_name, 'Energy' sector_name FROM dual UNION ALL
SELECT 'DMS121' symbol, 'Synthetic Real Estate Company 121 Limited' company_name, 'Real Estate' sector_name FROM dual UNION ALL
SELECT 'DMS122' symbol, 'Synthetic Consumer Goods Company 122 Limited' company_name, 'Consumer Goods' sector_name FROM dual UNION ALL
SELECT 'DMS123' symbol, 'Synthetic Materials Company 123 Limited' company_name, 'Materials' sector_name FROM dual UNION ALL
SELECT 'DMS124' symbol, 'Synthetic Information Technology Company 124 Limited' company_name, 'Information Technology' sector_name FROM dual UNION ALL
SELECT 'DMS125' symbol, 'Synthetic Financial Services Company 125 Limited' company_name, 'Financial Services' sector_name FROM dual UNION ALL
SELECT 'DMS126' symbol, 'Synthetic Banking Company 126 Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
SELECT 'DMS127' symbol, 'Synthetic Automobiles Company 127 Limited' company_name, 'Automobiles' sector_name FROM dual UNION ALL
SELECT 'DMS128' symbol, 'Synthetic Media Company 128 Limited' company_name, 'Media' sector_name FROM dual UNION ALL
SELECT 'DMS129' symbol, 'Synthetic Healthcare Company 129 Limited' company_name, 'Healthcare' sector_name FROM dual UNION ALL
SELECT 'DMS130' symbol, 'Synthetic Transport Company 130 Limited' company_name, 'Transport' sector_name FROM dual UNION ALL
SELECT 'DMS131' symbol, 'Synthetic Industrials Company 131 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS132' symbol, 'Synthetic Consumer Services Company 132 Limited' company_name, 'Consumer Services' sector_name FROM dual UNION ALL
SELECT 'DMS133' symbol, 'Synthetic Telecommunications Company 133 Limited' company_name, 'Telecommunications' sector_name FROM dual UNION ALL
SELECT 'DMS134' symbol, 'Synthetic Utilities Company 134 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS135' symbol, 'Synthetic Energy Company 135 Limited' company_name, 'Energy' sector_name FROM dual UNION ALL
SELECT 'DMS136' symbol, 'Synthetic Real Estate Company 136 Limited' company_name, 'Real Estate' sector_name FROM dual UNION ALL
SELECT 'DMS137' symbol, 'Synthetic Consumer Goods Company 137 Limited' company_name, 'Consumer Goods' sector_name FROM dual UNION ALL
SELECT 'DMS138' symbol, 'Synthetic Materials Company 138 Limited' company_name, 'Materials' sector_name FROM dual UNION ALL
SELECT 'DMS139' symbol, 'Synthetic Information Technology Company 139 Limited' company_name, 'Information Technology' sector_name FROM dual UNION ALL
SELECT 'DMS140' symbol, 'Synthetic Financial Services Company 140 Limited' company_name, 'Financial Services' sector_name FROM dual UNION ALL
SELECT 'DMS141' symbol, 'Synthetic Banking Company 141 Limited' company_name, 'Banking' sector_name FROM dual UNION ALL
SELECT 'DMS142' symbol, 'Synthetic Automobiles Company 142 Limited' company_name, 'Automobiles' sector_name FROM dual UNION ALL
SELECT 'DMS143' symbol, 'Synthetic Media Company 143 Limited' company_name, 'Media' sector_name FROM dual UNION ALL
SELECT 'DMS144' symbol, 'Synthetic Healthcare Company 144 Limited' company_name, 'Healthcare' sector_name FROM dual UNION ALL
SELECT 'DMS145' symbol, 'Synthetic Transport Company 145 Limited' company_name, 'Transport' sector_name FROM dual UNION ALL
SELECT 'DMS146' symbol, 'Synthetic Industrials Company 146 Limited' company_name, 'Industrials' sector_name FROM dual UNION ALL
SELECT 'DMS147' symbol, 'Synthetic Consumer Services Company 147 Limited' company_name, 'Consumer Services' sector_name FROM dual UNION ALL
SELECT 'DMS148' symbol, 'Synthetic Telecommunications Company 148 Limited' company_name, 'Telecommunications' sector_name FROM dual UNION ALL
SELECT 'DMS149' symbol, 'Synthetic Utilities Company 149 Limited' company_name, 'Utilities' sector_name FROM dual UNION ALL
SELECT 'DMS150' symbol, 'Synthetic Energy Company 150 Limited' company_name, 'Energy' sector_name FROM dual
) s ON (d.symbol=s.symbol) WHEN NOT MATCHED THEN INSERT (symbol,company_name,sector_id,exchange,active_flag) VALUES (s.symbol,s.company_name,(SELECT sector_id FROM sectors WHERE sector_name=s.sector_name),'NSE','Y');

-- 3) Create three additional portfolios for existing user 1, if absent.
DECLARE v_user_id NUMBER := 1; v_count NUMBER; BEGIN
 SELECT COUNT(*) INTO v_count FROM portfolios WHERE user_id=v_user_id AND portfolio_name='Balanced Opportunities'; IF v_count=0 THEN INSERT INTO portfolios(user_id,portfolio_name,description) VALUES(v_user_id,'Balanced Opportunities','Synthetic demo portfolio for diversified sector exposure'); END IF;
 SELECT COUNT(*) INTO v_count FROM portfolios WHERE user_id=v_user_id AND portfolio_name='Growth & Innovation'; IF v_count=0 THEN INSERT INTO portfolios(user_id,portfolio_name,description) VALUES(v_user_id,'Growth & Innovation','Synthetic demo portfolio focused on growth sectors'); END IF;
 SELECT COUNT(*) INTO v_count FROM portfolios WHERE user_id=v_user_id AND portfolio_name='Dividend & Value'; IF v_count=0 THEN INSERT INTO portfolios(user_id,portfolio_name,description) VALUES(v_user_id,'Dividend & Value','Synthetic demo portfolio for value-oriented holdings'); END IF;
END;
/

-- 4) Add 100 deterministic price observations per stock, spread over the prior year.
-- Existing prices on the same stock/date are preserved. Dates never exceed yesterday.
DECLARE v_date DATE; v_price NUMBER; v_stock_id NUMBER; v_base NUMBER; v_factor NUMBER; BEGIN
 FOR s IN (SELECT stock_id, symbol FROM stocks ORDER BY symbol) LOOP
   SELECT stock_id INTO v_stock_id FROM stocks WHERE stock_id=s.stock_id;
   v_base := 80 + MOD(s.stock_id*7919, 18000);
   FOR i IN 0..99 LOOP
     v_date := TRUNC(SYSDATE)-1-TRUNC(i*365/99);
     v_factor := 1 + (MOD(s.stock_id*37+i*17, 180)-90)/1000 + (i/1000);
     v_price := ROUND(GREATEST(5, v_base*v_factor),4);
     MERGE INTO historical_stock_prices d USING (SELECT v_stock_id stock_id, v_date price_date, v_price close_price FROM dual) x
       ON (d.stock_id=x.stock_id AND d.price_date=x.price_date)
       WHEN NOT MATCHED THEN INSERT(stock_id,price_date,close_price,source_label) VALUES(x.stock_id,x.price_date,x.close_price,'SYNTHETIC DEMO - NOT MARKET DATA');
   END LOOP;
 END LOOP;
END;
/

-- 5) Add stocks to user 1's watchlist without duplicating existing entries.
INSERT INTO watchlist(user_id,stock_id) SELECT 1,s.stock_id FROM stocks s WHERE NOT EXISTS (SELECT 1 FROM watchlist w WHERE w.user_id=1 AND w.stock_id=s.stock_id) AND s.symbol LIKE 'DMS%';

-- 6) Add 350 buys followed by 150 sells using existing procedures, preserving holdings logic.
-- Unique notes are the idempotency key. Sell trades reference the first 150 buy positions.
DECLARE
 v_portfolios SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
 v_stock_ids SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
 v_pid NUMBER; v_sid NUMBER; v_qty NUMBER; v_price NUMBER; v_fees NUMBER; v_dt DATE; v_count NUMBER; v_note VARCHAR2(200);
BEGIN
 SELECT portfolio_id BULK COLLECT INTO v_portfolios FROM portfolios WHERE user_id=1 ORDER BY portfolio_id;
 SELECT stock_id BULK COLLECT INTO v_stock_ids FROM stocks ORDER BY stock_id;
 IF v_portfolios.COUNT < 5 OR v_stock_ids.COUNT < 150 THEN RAISE_APPLICATION_ERROR(-20101,'Expected at least 5 portfolios and 150 stocks.'); END IF;
 -- Buy transactions (1..350).
 FOR i IN 1..350 LOOP
   v_pid := v_portfolios(MOD(i-1,5)+1);
   v_sid := v_stock_ids(MOD((i-1)*37+11,v_stock_ids.COUNT)+1);
   v_qty := 5 + MOD(i*17,96);
   v_price := ROUND(80 + MOD(i*791,15000) + MOD(i*13,100)/100,4);
   v_fees := ROUND(v_qty*v_price*0.001,4);
   v_dt := TRUNC(SYSDATE)-365+MOD(i*13,300);
   v_note := 'SYNTHETIC_DEMO_V2|BUY|'||LPAD(i,4,'0');
   SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE notes=v_note;
   IF v_count=0 THEN add_buy_transaction(v_pid,v_sid,v_qty,v_price,v_dt,v_fees,v_note); END IF;
 END LOOP;
 -- Sell 150 shares of the matching first 150 buy positions, half quantity (always <= bought).
 FOR i IN 1..150 LOOP
   v_pid := v_portfolios(MOD(i-1,5)+1);
   v_sid := v_stock_ids(MOD((i-1)*37+11,v_stock_ids.COUNT)+1);
   v_qty := (5 + MOD(i*17,96))/2;
   v_price := ROUND(80 + MOD((i+350)*791,15000) + MOD(i*19,100)/100,4);
   v_fees := ROUND(v_qty*v_price*0.001,4);
   v_dt := TRUNC(SYSDATE)-1-MOD(i,25);
   v_note := 'SYNTHETIC_DEMO_V2|SELL|'||LPAD(i,4,'0');
   SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE notes=v_note;
   IF v_count=0 THEN
     -- Ensure the chosen position exists; the corresponding buy may be skipped only on a complete prior run.
     BEGIN add_sell_transaction(v_pid,v_sid,v_qty,v_price,v_dt,v_fees,v_note);
     EXCEPTION WHEN OTHERS THEN
       IF SQLCODE=-20004 OR SQLCODE=-20005 THEN
         -- Existing portfolio history may have affected this position; leave a clear error rather than corrupt data.
         RAISE;
       ELSE RAISE; END IF;
     END;
   END IF;
 END LOOP;
END;
/

COMMIT;

PROMPT === Large demo dataset counts ===
SELECT COUNT(*) AS total_stocks FROM stocks;
SELECT COUNT(*) AS total_price_rows FROM historical_stock_prices;
SELECT COUNT(*) AS total_transactions FROM portfolio_transaction;
SELECT COUNT(*) AS total_holdings FROM holdings;
SELECT COUNT(*) AS total_portfolios FROM portfolios WHERE user_id=1;
SELECT COUNT(*) AS total_watchlist_items FROM watchlist WHERE user_id=1;
PROMPT === Synthetic records are labelled; no real market prices are claimed. ===
EXIT SUCCESS