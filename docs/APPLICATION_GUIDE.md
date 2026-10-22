# Application Guide

Start at Settings and test the configured Oracle endpoint. Then dashboard cards load database-derived values. Create a portfolio from Portfolios, browse stored stock master data in Stock Explorer, and record a trade through Buy/Sell. The confirmation dialog precedes the JDBC call; an oversell is rejected by the stored procedure. Choose a portfolio in Holdings to inspect the weighted-average open positions.

The Watchlist add action persists an Oracle row and relies on a unique constraint for duplicates. Transaction History, Price History, and Analytics expose the corresponding navigable product areas and point to the live SQL report catalog while the database-backed query controls are extended. All prices are explicitly labelled as stored demonstration values rather than real-time quotations.

For report screenshots, connect Oracle, run the app, and capture: Dashboard, Portfolios, Stock Explorer, Buy form, Sell form, Holdings, Transactions, Watchlist, Analytics, About, and Settings. Save them under `docs/screenshots/` before final submission.
