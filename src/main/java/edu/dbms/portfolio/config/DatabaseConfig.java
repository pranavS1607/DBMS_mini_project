package edu.dbms.portfolio.config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

/** Loads non-secret defaults from the environment, with optional ignored .env support. */
public record DatabaseConfig(String url, String username, String password) {
    public static DatabaseConfig load() {
        Properties values = new Properties();
        Path env = Path.of(".env");
        if (Files.isRegularFile(env)) try (InputStream in = Files.newInputStream(env)) { values.load(in); } catch (IOException ignored) { }
        return new DatabaseConfig(value("ORACLE_JDBC_URL", values), value("ORACLE_DB_USER", values), value("ORACLE_DB_PASSWORD", values));
    }
    private static String value(String key, Properties values) {
        String env = System.getenv(key);
        return env != null && !env.isBlank() ? env : values.getProperty(key, "").trim();
    }
    public boolean isConfigured() { return !url.isBlank() && !username.isBlank() && !password.isBlank(); }
    public String safeEndpoint() { return url.replaceAll("(?i)(password|pwd)=[^;]+", "$1=***"); }
}
