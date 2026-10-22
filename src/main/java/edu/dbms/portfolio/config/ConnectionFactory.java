package edu.dbms.portfolio.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class ConnectionFactory {
    private final DatabaseConfig config;
    public ConnectionFactory(DatabaseConfig config) { this.config = config; }
    public Connection open() throws SQLException {
        if (!config.isConfigured()) throw new SQLException("Database configuration is incomplete. Set ORACLE_JDBC_URL, ORACLE_DB_USER and ORACLE_DB_PASSWORD.");
        Connection connection = DriverManager.getConnection(config.url(), config.username(), config.password());
        connection.setAutoCommit(false); // procedures and their ledger/holding mutations commit together.
        return connection;
    }
    public boolean testConnection() throws SQLException { try (Connection ignored = open()) { return true; } }
}
