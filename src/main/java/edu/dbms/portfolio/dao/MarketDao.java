package edu.dbms.portfolio.dao;

import edu.dbms.portfolio.config.ConnectionFactory;
import edu.dbms.portfolio.model.Holding;
import edu.dbms.portfolio.model.Stock;
import edu.dbms.portfolio.model.LedgerRow;
import edu.dbms.portfolio.model.PriceRecord;
import edu.dbms.portfolio.model.TransactionType;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public final class MarketDao {
    private final ConnectionFactory connections;
    public MarketDao(ConnectionFactory connections) { this.connections=connections; }
    public List<Stock> stocks(String term, String sector) throws SQLException {
        String sql="SELECT s.stock_id,s.symbol,s.company_name,se.sector_name,s.exchange,latest.close_price,latest.price_date FROM stocks s JOIN sectors se ON se.sector_id=s.sector_id LEFT JOIN (SELECT stock_id,close_price,price_date,ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY price_date DESC) rn FROM historical_stock_prices) latest ON latest.stock_id=s.stock_id AND latest.rn=1 WHERE (UPPER(s.symbol) LIKE UPPER(?) OR UPPER(s.company_name) LIKE UPPER(?)) AND (? IS NULL OR se.sector_name=?) ORDER BY s.symbol";
        List<Stock> all=new ArrayList<>(); try(Connection c=connections.open();PreparedStatement s=c.prepareStatement(sql)){String q="%"+(term==null?"":term.trim())+"%"; s.setString(1,q);s.setString(2,q);if(sector==null||sector.isBlank()){s.setNull(3,Types.VARCHAR);s.setNull(4,Types.VARCHAR);}else{s.setString(3,sector);s.setString(4,sector);}try(ResultSet r=s.executeQuery()){while(r.next())all.add(new Stock(r.getLong(1),r.getString(2),r.getString(3),r.getString(4),r.getString(5),r.getBigDecimal(6),r.getDate(7)==null?null:r.getDate(7).toLocalDate()));}}return all;
    }
    public List<Holding> holdings(long portfolioId) throws SQLException {
        String sql="SELECT s.symbol,s.company_name,h.quantity,h.average_cost,h.cost_basis,p.close_price,h.quantity*p.close_price,h.quantity*p.close_price-h.cost_basis FROM holdings h JOIN stocks s ON s.stock_id=h.stock_id LEFT JOIN (SELECT stock_id,close_price,ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY price_date DESC) rn FROM historical_stock_prices) p ON p.stock_id=h.stock_id AND p.rn=1 WHERE h.portfolio_id=? AND h.quantity>0 ORDER BY 7 DESC";
        List<Holding> all=new ArrayList<>(); try(Connection c=connections.open();PreparedStatement s=c.prepareStatement(sql)){s.setLong(1,portfolioId);try(ResultSet r=s.executeQuery()){while(r.next())all.add(new Holding(r.getString(1),r.getString(2),d(r,3),d(r,4),d(r,5),d(r,6),d(r,7),d(r,8)));}}return all;
    }
    public void addWatchlist(long userId,long stockId)throws SQLException {try(Connection c=connections.open();PreparedStatement s=c.prepareStatement("INSERT INTO watchlist(user_id,stock_id) VALUES (?,?)")){s.setLong(1,userId);s.setLong(2,stockId);s.executeUpdate();c.commit();}}
    public List<Stock> watchlist(long userId) throws SQLException {
        String sql="SELECT s.stock_id,s.symbol,s.company_name,se.sector_name,s.exchange,lp.close_price,lp.price_date FROM watchlist w JOIN stocks s ON s.stock_id=w.stock_id JOIN sectors se ON se.sector_id=s.sector_id LEFT JOIN (SELECT stock_id,close_price,price_date,ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY price_date DESC) rn FROM historical_stock_prices) lp ON lp.stock_id=s.stock_id AND lp.rn=1 WHERE w.user_id=? ORDER BY s.symbol";
        List<Stock> all=new ArrayList<>();try(Connection c=connections.open();PreparedStatement q=c.prepareStatement(sql)){q.setLong(1,userId);try(ResultSet r=q.executeQuery()){while(r.next())all.add(new Stock(r.getLong(1),r.getString(2),r.getString(3),r.getString(4),r.getString(5),r.getBigDecimal(6),r.getDate(7)==null?null:r.getDate(7).toLocalDate()));}}return all;
    }
    public void removeWatchlist(long userId,long stockId)throws SQLException {try(Connection c=connections.open();PreparedStatement s=c.prepareStatement("DELETE FROM watchlist WHERE user_id=? AND stock_id=?")){s.setLong(1,userId);s.setLong(2,stockId);s.executeUpdate();c.commit();}}
    public List<LedgerRow> transactions(long userId) throws SQLException {String sql="SELECT t.transaction_date,p.portfolio_name,s.symbol,t.transaction_type,t.quantity,t.execution_price,t.fees,t.realized_pl FROM portfolio_transaction t JOIN portfolios p ON p.portfolio_id=t.portfolio_id JOIN stocks s ON s.stock_id=t.stock_id WHERE p.user_id=? ORDER BY t.transaction_date DESC,t.transaction_id DESC";List<LedgerRow> all=new ArrayList<>();try(Connection c=connections.open();PreparedStatement q=c.prepareStatement(sql)){q.setLong(1,userId);try(ResultSet r=q.executeQuery()){while(r.next())all.add(new LedgerRow(r.getDate(1).toLocalDate(),r.getString(2),r.getString(3),TransactionType.valueOf(r.getString(4)),d(r,5),d(r,6),d(r,7),d(r,8)));}}return all;}
    public List<PriceRecord> prices(String symbol) throws SQLException {String sql="SELECT s.symbol,p.price_date,p.close_price,p.source_label FROM historical_stock_prices p JOIN stocks s ON s.stock_id=p.stock_id WHERE (? IS NULL OR s.symbol=?) ORDER BY s.symbol,p.price_date DESC";List<PriceRecord> all=new ArrayList<>();try(Connection c=connections.open();PreparedStatement q=c.prepareStatement(sql)){if(symbol==null||symbol.isBlank()){q.setNull(1,Types.VARCHAR);q.setNull(2,Types.VARCHAR);}else{q.setString(1,symbol);q.setString(2,symbol);}try(ResultSet r=q.executeQuery()){while(r.next())all.add(new PriceRecord(r.getString(1),r.getDate(2).toLocalDate(),d(r,3),r.getString(4)));}}return all;}
    private static BigDecimal d(ResultSet r,int n)throws SQLException {BigDecimal x=r.getBigDecimal(n);return x==null?BigDecimal.ZERO:x;}
}
