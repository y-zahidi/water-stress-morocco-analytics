# System Architecture

## Overview

This document describes the technical architecture behind the Water Stress Analysis System.

---

## Three-Tier Architecture

The system follows a classic data warehouse pattern:

### Tier 1: Data Sources (Simulated)

In a production environment, data would flow from:
- **Meteorological stations** - Rainfall, temperature, evaporation
- **Dam monitoring systems** - Reservoir levels, releases
- **Water utility meters** - Consumption by sector
- **Groundwater wells** - Aquifer levels

For this project, I built a synthetic data generator that produces statistically realistic values matching published FAO/World Bank figures.

### Tier 2: Data Warehouse (MySQL)

**Schema Type:** Star Schema (Kimball methodology)

**Why star schema?**
- Simple for analysts to understand
- Fast query performance (fewer joins)
- Optimized for BI tools like QlikView

**Components:**
- **4 Dimensions:** Regions (12), Cities (46), Time (131 months), Sectors (4)
- **3 Facts:** Water availability, Stress index, Consumption
- **Granularity:** Monthly (balances detail vs. volume)

**Design decisions:**
- InnoDB engine for foreign key support
- UTF-8mb4 for Arabic city names
- Composite UNIQUE keys prevent duplicates
- ON DELETE RESTRICT protects referential integrity

### Tier 3: Business Intelligence (QlikView)

**Connection:** ODBC to MySQL (read-only user)

**Data Model:** Star schema with Link Table (eliminates synthetic keys)

**Dashboards:**
- National view (regional comparison)
- City view (drill-down with filters)
- Temporal trends (monthly evolution)

---

## Data Flow

Monthly update cycle:

1. **Day 1-2:** Source systems finalize previous month's data
2. **Day 3 (2 AM):** ETL job triggered
   - Extract from sources
   - Transform (clean, validate, calculate metrics)
   - Load into MySQL fact tables
3. **Day 3 (6 AM):** QlikView scheduled reload
4. **Day 3 (8 AM):** Users access updated dashboards

---

## Technologies Justification

**Why MySQL?**
- Free, open-source, widely used
- InnoDB engine supports transactions and foreign keys
- Good performance for small-to-medium OLAP workloads

**Why QlikView?**
- Required for the academic course
- In-memory engine = fast on small datasets
- Associative model allows flexible exploration

**Future migration path:**
- MySQL → PostgreSQL (better window functions)
- QlikView → Qlik Sense (cloud, modern UI)

---

## Security Considerations

**Database:**
- Role-based access (read-only for BI, write for ETL)
- SSL connections enforced
- Password complexity rules

**Network:**
- VPN required for remote access
- Firewall restricts MySQL port 3306

**Data:**
- Synthetic (no real PII or sensitive info)
- In production: row-level security in QlikView

---

## Scalability

**Current state:**
- 68K records, sub-second queries
- Single MySQL server, desktop QlikView

**Production scaling (if deployed):**
- Partition fact tables by year
- Materialized views for common aggregations
- Migrate to Qlik Sense (cloud-based)
- Archive data older than 5 years

**Projected growth:**
- With daily grain: 2.4M records/year
- 10-year history: 24M records
- Still manageable with proper indexing and partitioning

---

For implementation details, see the [Data Dictionary](./data_dictionary.md).
