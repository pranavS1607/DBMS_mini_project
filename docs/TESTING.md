# Testing Record

## Executed in this environment

- Static review completed: Java class/package paths, resource path, Maven coordinates, SQL object names, JDBC procedure signatures, and script order were checked.
- Java/Maven build was **not executed** because `java` and `mvn` are not installed or discoverable on this computer.
- Oracle integration tests were **not executed** because no Oracle endpoint or credentials were supplied.

## Required local verification

Run `mvn clean test` then `mvn javafx:run`. In SQL*Plus run `01` through `08` in order. Verify a valid buy creates/increases a holding, a valid sell reduces it, a 999999-share sell fails with `ORA-20004`, the duplicate watchlist test fails with `ORA-00001`, and audit entries exist. Do not mark those results as passed until run against the local database.
