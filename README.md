# 💧 Water Stress Morocco — Data Warehouse & BI

> An end-to-end **data warehouse + business-intelligence** system analysing water stress across Morocco's 12 regions over a 10-year period. Built with **MySQL** (star schema) and **QlikView** (BI dashboards).

![Status](https://img.shields.io/badge/status-active-success)
![License](https://img.shields.io/badge/license-Proprietary-red)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql&logoColor=white)
![QlikView](https://img.shields.io/badge/QlikView-11.x-orange?logo=qlik&logoColor=white)

---

## At a glance

Morocco is in a quiet water crisis. This project is my attempt to build the data infrastructure you'd need to understand and act on it — at the scale and shape of a real government decision-support system.

- **12 regions · 46 cities · 10 years (2015 – 2025) · 68,000+ records**
- **MySQL star schema** with 7 tables (1 fact + 6 dimensions)
- **QlikView dashboards** with KPIs, regional comparisons, trend analysis
- **Python ETL** scripts that simulate a continuous monthly data feed
- **Production-ready architecture**, populated with synthesized data

> **The data is synthetic** (for learning and privacy reasons). The architecture is what you'd use with real government data feeds.

---

## Why I built this

Three reasons drove this:

1. **Real-world relevance.** Water scarcity is happening *now* in Morocco. Anyone growing up here has watched dams shrink and aquifers drop.
2. **Technical challenge.** I wanted hands-on practice with dimensional modelling, ETL design, and BI on a problem that wasn't toy-sized.
3. **Portfolio piece.** Demonstrating end-to-end data engineering — schema design through dashboards — on a meaningful subject.

The architecture and analytical approach are designed to plug into real government feeds the day they become available.

---

## Architecture

```
┌──────────────────────────────────────┐
│       Data Sources (Simulated)       │
│  Weather Stations · Dams · Sensors   │
└────────────┬─────────────────────────┘
             │
             ▼
┌──────────────────────────────────────┐
│      ETL Processing Layer            │
│  Extract · Transform · Load (Python) │
└────────────┬─────────────────────────┘
             │
             ▼
┌──────────────────────────────────────┐
│   MySQL Data Warehouse (InnoDB)      │
│   Star schema — 7 tables             │
│   Fact_WaterStress + 6 dimensions    │
└────────────┬─────────────────────────┘
             │ ODBC (Unicode driver)
             ▼
┌──────────────────────────────────────┐
│      QlikView BI Platform            │
│   Interactive dashboards & KPIs      │
└──────────────────────────────────────┘
```

### Star schema

```
                   ┌──────────────┐
                   │ Dim_Region   │
                   └──────┬───────┘
                          │
┌─────────────┐    ┌──────▼──────────────────┐    ┌──────────────┐
│ Dim_Time    │───▶│   Fact_WaterStress      │◀───│ Dim_City     │
└─────────────┘    │  • measure_id           │    └──────────────┘
                   │  • stress_pct           │
┌─────────────┐    │  • availability_m3      │    ┌──────────────┐
│ Dim_Source  │───▶│  • consumption_m3       │◀───│ Dim_Sector   │
└─────────────┘    │  • temperature_c        │    └──────────────┘
                   │  • precipitation_mm     │
                   └─────────┬───────────────┘
                             │
                       ┌─────▼────────┐
                       │ Dim_Severity │
                       └──────────────┘
```

**Why a star schema (not a snowflake or 3NF):**
- Optimal for read-heavy analytical workloads (which is what BI is).
- Joins are simple and predictable for QlikView's load script.
- Trades disk for query speed — a fair trade for analytics.

---

## Tech stack

| Layer | Tech |
|-------|------|
| Database | MySQL 8.0 (InnoDB) |
| BI tool | QlikView 11.x (a Qlik Sense migration is in the roadmap) |
| Connectivity | ODBC Unicode Driver |
| ETL & data generation | Python 3 |
| Reporting | QlikView Script |

---

## What the data reveals (synthesised)

Even with simulated data calibrated against public Moroccan averages, the patterns are concerning.

### National overview (2024 snapshot)
- **National stress level:** 74.2% — classified "High"
- **Critical regions:** 5 of 12 above the 80% emergency threshold
- **Trend:** Water availability declining at ~1.5% per year
- **Top consumer:** Agriculture (≈ 70% of total water use)

### Regional disparities (North–South gradient)

| Region | Stress (%) | Classification |
|---|---|---|
| 🔴 Laâyoune-Sakia El Hamra | 88.4 | Extreme |
| 🔴 Guelmim-Oued Noun | 86.7 | Extreme |
| 🔴 Drâa-Tafilalet | 84.1 | Extreme |
| 🟢 Tanger-Tétouan-Al Hoceima | 66.4 | Moderate |
| 🟢 Rabat-Salé-Kénitra | 67.8 | Moderate |

The southern regions, being more arid, consistently show higher stress — matching real-world observations.

### 10-year trend
- 2015: 72.5% average national stress
- 2024: 74.2% average national stress
- 2030 projection (linear extrapolation): ~76%

---

## Dashboards (QlikView)

Five dashboards ship with the project:

1. **National overview** — high-level KPIs, current stress map, top consumers
2. **Regional comparison** — bar chart of all 12 regions, drill-down to cities
3. **Time evolution** — 10-year trend lines per region with overlay annotations
4. **Sectoral analysis** — agriculture vs industry vs domestic consumption breakdown
5. **Source analysis** — surface water vs groundwater vs desalination contribution

(Screenshots in `screenshots/`.)

---

## What I learned building this

- **Star schemas pay off immediately for BI.** Trying to query a 3NF schema from QlikView would have been painful. The denormalisation is worth the disk.
- **ETL is 80% of the work.** Building the dashboards was 1 week. Building the simulated data + ETL pipeline that respects realistic seasonality and inter-regional correlations was 3 weeks.
- **QlikView's "associative model" is genuinely different.** Coming from SQL, it took a full weekend to internalise that filtering one table cascades to all linked tables automatically.
- **Synthesised data must be plausible.** Random numbers look fake on a chart. I had to model winter/summer seasonality, multi-year drought cycles, and regional baselines to make the dashboards usable as a portfolio piece.

---

## Roadmap

- [x] Star schema + 7 tables
- [x] Python ETL with simulated monthly feed
- [x] 5 QlikView dashboards
- [ ] Migrate to **Qlik Sense** (modern UI, web-native)
- [ ] Replace simulated data with HCEFLCD / ABH public datasets when available
- [ ] Add a forecasting layer (ARIMA / Prophet) for 2030 projections
- [ ] Containerise (MySQL + ETL) for one-command spin-up

---

## License

Proprietary — full source not publicly available. This repo is a portfolio showcase with architecture, screenshots, schema, and findings.

---

## About me

I'm **Yassir Zahidi**, Computer Engineering student at ISMAGI (Rabat) with a 2-year Cybersecurity background (ISMO Tétouan). Currently looking for a **PFE / internship in cybersecurity, data engineering or DevSecOps** for 2026.

- 🌐 [LinkedIn](https://www.linkedin.com/in/yassir-zahidi/)
- 📧 yassirzahidi8@gmail.com
- 💻 [github.com/y-zahidi](https://github.com/y-zahidi)
