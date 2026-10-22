package edu.dbms.portfolio.util;

import java.math.BigDecimal;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

class MoneyTest {
    @Test void formatsIndianCurrencyWithoutNullFailure() {
        assertTrue(Money.format(new BigDecimal("1250.50")).contains("1"));
        assertTrue(Money.format(null).contains("0"));
    }
}
