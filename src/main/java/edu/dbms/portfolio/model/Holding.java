package edu.dbms.portfolio.model;
import java.math.BigDecimal;
public record Holding(String symbol, String company, BigDecimal quantity, BigDecimal averageCost, BigDecimal costBasis, BigDecimal marketPrice, BigDecimal marketValue, BigDecimal unrealizedPl) { }
