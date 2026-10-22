package edu.dbms.portfolio.model;
import java.math.BigDecimal;
import java.time.LocalDate;
public record Stock(long id, String symbol, String companyName, String sector, String exchange, BigDecimal price, LocalDate priceDate) { }
