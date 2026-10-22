# Project Overview

Portfolio Management Database System is a single-user academic demonstration of normalized Oracle data management for equity portfolios. The system keeps an auditable buy/sell ledger and separately materializes only current open positions in `HOLDINGS`. This separation makes historical reporting possible without reconstructing a position from the most recent trade.

The JavaFX desktop client has Dashboard, Portfolios, Stock Explorer, Buy/Sell, Holdings, Watchlist, Transactions, Price History, Analytics, About, and Settings navigation. It uses no mock fallback: if Oracle cannot be reached, the client identifies that state instead of presenting invented financial data.

### Cost-basis policy

Buy fees are capitalized into the weighted-average cost basis. A sale removes quantity at current average cost and saves `proceeds - sale fees - removed cost` as realised P/L. A zero position is removed from `HOLDINGS`; its history remains in `PORTFOLIO_TRANSACTION`.
