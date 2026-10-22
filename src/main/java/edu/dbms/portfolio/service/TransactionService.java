package edu.dbms.portfolio.service;

import edu.dbms.portfolio.config.ConnectionFactory;
import edu.dbms.portfolio.model.TransactionType;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;

/** A PL/SQL procedure owns the atomic ledger-and-holding mutation. */
public final class TransactionService {
    private final ConnectionFactory connections;
    public TransactionService(ConnectionFactory connections) {this.connections=connections;}
    public void submit(long portfolioId,long stockId,TransactionType type,BigDecimal quantity,BigDecimal price,LocalDate date,BigDecimal fees,String notes)throws SQLException {
        if(quantity==null||quantity.signum()<=0||price==null||price.signum()<=0) throw new IllegalArgumentException("Quantity and execution price must be positive.");
        String call= type==TransactionType.BUY?"{ call add_buy_transaction(?,?,?,?,?,?,?) }":"{ call add_sell_transaction(?,?,?,?,?,?,?) }";
        try(Connection c=connections.open();CallableStatement s=c.prepareCall(call)){s.setLong(1,portfolioId);s.setLong(2,stockId);s.setBigDecimal(3,quantity);s.setBigDecimal(4,price);s.setDate(5,Date.valueOf(date));s.setBigDecimal(6,fees==null?BigDecimal.ZERO:fees);s.setString(7,notes);s.execute();c.commit();}
    }
}
