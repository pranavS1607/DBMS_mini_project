package edu.dbms.portfolio.model;
import java.math.BigDecimal;
import java.time.LocalDate;
public record LedgerRow(LocalDate date,String portfolio,String symbol,TransactionType type,BigDecimal quantity,BigDecimal price,BigDecimal fees,BigDecimal realisedPl) { }
