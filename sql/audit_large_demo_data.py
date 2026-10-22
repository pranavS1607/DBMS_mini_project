#!/usr/bin/env python3
"""Small local audit helper for the portfolio demo dataset. No DB credentials required."""
from pathlib import Path
import re

SQL_FILE = Path(__file__).with_name("12_large_demo_data.sql")
text = SQL_FILE.read_text(encoding="utf-8")
checks = {
    "synthetic stock rows declared": len(re.findall(r"SELECT 'DMS\d{3}' symbol", text)),
    "price observations per stock": 100 if "FOR i IN 0..99 LOOP" in text else 0,
    "buy transactions planned": 350 if "FOR i IN 1..350 LOOP" in text else 0,
    "sell transactions planned": 150 if "FOR i IN 1..150 LOOP" in text else 0,
    "rerun guards present": text.count("SELECT COUNT(*) INTO v_count FROM portfolio_transaction WHERE notes=v_note;") >= 2,
    "synthetic price label present": "SYNTHETIC DEMO - NOT MARKET DATA" in text,
    "destructive reset absent": "DROP TABLE" not in text.upper() and "TRUNCATE TABLE" not in text.upper(),
}
for label, value in checks.items():
    print(f"{'PASS' if value else 'CHECK'}  {label}: {value}")
if not all(bool(v) for v in checks.values()):
    raise SystemExit(1)
