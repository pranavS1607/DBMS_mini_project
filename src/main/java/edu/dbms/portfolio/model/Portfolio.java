package edu.dbms.portfolio.model;
import java.math.BigDecimal;
public record Portfolio(long id, String name, String description, BigDecimal invested, BigDecimal marketValue, BigDecimal unrealizedPl) { }
