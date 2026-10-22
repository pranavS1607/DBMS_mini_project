package edu.dbms.portfolio.model;
import java.math.BigDecimal;
import java.time.LocalDate;
public record PriceRecord(String symbol,LocalDate date,BigDecimal closePrice,String source) { }
