package edu.dbms.portfolio.util;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;
public final class Money { private Money() {} public static String format(BigDecimal value) { return NumberFormat.getCurrencyInstance(new Locale("en", "IN")).format(value == null ? BigDecimal.ZERO : value); } }
