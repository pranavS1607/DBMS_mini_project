package edu.dbms.portfolio.dao;

import edu.dbms.portfolio.config.ConnectionFactory;
import edu.dbms.portfolio.model.Portfolio;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/** Queries only persisted Oracle data; there is deliberately no mock-data fallback. */
public final class PortfolioDao {
    private final ConnectionFactory connections;
    public PortfolioDao(ConnectionFactory connections) { this.connections = connections; }
    public List<Portfolio> listForUser(long userId) throws SQLException {
        String sql = "SELECT p.portfolio_id,p.portfolio_name,p.description, portfolio_cost_basis(p.portfolio_id) invested, portfolio_market_value(p.portfolio_id) value, portfolio_unrealized_pl(p.portfolio_id) pl FROM portfolios p WHERE p.user_id=? ORDER BY p.portfolio_name";
        List<Portfolio> result = new ArrayList<>();
        try (Connection c=connections.open(); PreparedStatement s=c.prepareStatement(sql)) { s.setLong(1,userId); try(ResultSet r=s.executeQuery()) { while(r.next()) result.add(new Portfolio(r.getLong(1),r.getString(2),r.getString(3),decimal(r,4),decimal(r,5),decimal(r,6))); } }
        return result;
    }
    public long create(long userId, String name, String description) throws SQLException {
        try (Connection c=connections.open(); CallableStatement s=c.prepareCall("{ call create_portfolio(?,?,?,?) }")) { s.setLong(1,userId); s.setString(2,name); s.setString(3,description); s.registerOutParameter(4,Types.NUMERIC); s.execute(); c.commit(); return s.getLong(4); }
    }
    public void update(long id, String name, String description) throws SQLException { try(Connection c=connections.open(); PreparedStatement s=c.prepareStatement("UPDATE portfolios SET portfolio_name=?, description=?, updated_at=SYSTIMESTAMP WHERE portfolio_id=?")){s.setString(1,name);s.setString(2,description);s.setLong(3,id); if(s.executeUpdate()!=1) throw new SQLException("Portfolio was not found."); c.commit();} }
    public void delete(long id) throws SQLException { try(Connection c=connections.open(); PreparedStatement s=c.prepareStatement("DELETE FROM portfolios WHERE portfolio_id=?")){s.setLong(1,id);s.executeUpdate();c.commit();} }
    private static BigDecimal decimal(ResultSet r,int index)throws SQLException { BigDecimal v=r.getBigDecimal(index); return v==null?BigDecimal.ZERO:v; }
}
