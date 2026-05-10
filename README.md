# water-stress-morocco-analytics

> Data warehouse and BI on water stress across **Morocco's 12 regions, 46 cities, 131 months (Jan 2015 – Nov 2025)** — MySQL star schema, ~68k records, QlikView dashboards. Synthetic data, production-grade architecture.

![status](https://img.shields.io/badge/status-active-5cf2c1?labelColor=0a0e14)
![license](https://img.shields.io/badge/license-proprietary-5cf2c1?labelColor=0a0e14)
![mysql](https://img.shields.io/badge/mysql-8.0-5cf2c1?labelColor=0a0e14)
![qlikview](https://img.shields.io/badge/qlikview-11.x-5cf2c1?labelColor=0a0e14)

## What this is

A 6-week portfolio project I built during the 2025–2026 academic year. Morocco has a real water-stress problem; the goal here was to model it with the kind of data architecture an actual water agency would need. Data is synthetic — generated to match published FAO and World Bank aggregate figures within ±3%. Architecture is production-shaped.

## What's in the warehouse

- **12 regions, 46 cities** (every administrative subdivision in Morocco).
- **131 months** of data (Jan 2015 → Nov 2025).
- **4 economic sectors** (agriculture, industry, domestic, services).
- **6 153 monthly availability records** + **24 597 consumption records** + ~37k dependent rows.
- Star schema with 7 tables; foreign keys enforced; CHECK constraints in place.

## Architecture

```
┌──────────────────────────────────────┐
│   Data sources (simulated)           │
│   weather stations · dams · sensors  │
└──────────────┬───────────────────────┘
               │   Python ETL
               ▼
┌──────────────────────────────────────┐
│   MySQL data warehouse (InnoDB)      │
│   star schema, 7 tables, 68k records │
└──────────────┬───────────────────────┘
               │   ODBC Unicode
               ▼
┌──────────────────────────────────────┐
│   QlikView 11.x — dashboards & KPIs  │
└──────────────────────────────────────┘
```

## What the data shows

Even synthetic, the patterns are recognisable. National stress index for 2024 sits at **74%** ("high"). Five regions of twelve are above the 80% emergency threshold. Southern regions consistently outpace northern ones. Trend line over the decade is +1.7 percentage points — getting worse, not better.

| Region | 2024 stress | Classification |
|---|---|---|
| Laâyoune-Sakia El Hamra | 88.4% | Extreme |
| Guelmim-Oued Noun | 86.7% | Extreme |
| Drâa-Tafilalet | 84.1% | Extreme |
| Tanger-Tétouan-Al Hoceima | 66.4% | Moderate |
| Rabat-Salé-Kénitra | 67.8% | Moderate |

## Screenshots

| Database overview | Data model |
|:--:|:--:|
| ![tables](screenshots/mysql_tables_overview.png) | ![model](screenshots/qlikview_data_model.png) |
| **National dashboard (2020 — Drâa-Tafilalet)** | **City drill-down (2022)** |
| ![national](screenshots/dashboard_national_2020.png) | ![cities](screenshots/dashboard_cities_2022.png) |

## Two technical problems worth talking about

**1 — QlikView synthetic keys.** Multiple fact tables sharing the same dimension keys (`city_id`, `month_id`) make QlikView auto-generate `$Syn1`, `$Syn2` keys, which produce unreliable aggregations. I solved it with an explicit link table:

```qlik
DispoM:
LOAD
    AutoNumberHash128(ville_id, mois_id) AS %VilleMoisKey,
    ville_id AS %VilleID,
    mois_id  AS %MoisID,
    volume_total_km3 AS [Volume Total (km³)]
FROM volumes_eau_disponibles_m;

LinkVilleMois:
LOAD DISTINCT
    %VilleMoisKey, %VilleID, %MoisID
RESIDENT DispoM;

DROP FIELDS %VilleID, %MoisID FROM DispoM;  // forces use of link table
```

Result: clean star schema, zero synthetic keys, predictable aggregations.

**2 — Generating realistic synthetic data.** Real water data is confidential. I built a deterministic model with three components — long-term decline, seasonal cycle, pseudo-random variation:

```python
volume = base_volume \
       * (0.985 ** years_since_2015) \
       * (1 + amplitude * cos(2 * pi * month / 12)) \
       * (1 + crc32_noise)
```

Validated against FAO + World Bank aggregate figures: matches within 3%.

## A query that actually runs the dashboard

```sql
-- Rank regions by average stress level in 2024
SELECT
    r.nom_region                                      AS region,
    ROUND(AVG(s.indice_stress) * 100, 1)              AS avg_stress_pct,
    COUNT(CASE WHEN s.indice_stress >= 0.80 THEN 1 END) AS critical_months,
    ROUND(MAX(s.indice_stress) * 100, 1)              AS worst_month_pct
FROM   indice_stress_hydrique_m s
JOIN   villes  v ON s.ville_id  = v.ville_id
JOIN   regions r ON v.region_id = r.region_id
JOIN   dim_mois d ON s.mois_id  = d.mois_id
WHERE  d.annee = 2024
GROUP BY r.nom_region
ORDER BY avg_stress_pct DESC;
```

## Documentation

- [`docs/architecture.md`](docs/architecture.md) — three-tier design.
- [`docs/data_dictionary.md`](docs/data_dictionary.md) — schema reference.
- [`code-snippets/`](code-snippets/) — SQL + QlikView extracts.

## What I learned

- Star schema vs snowflake trade-offs in practice.
- When (and why) to denormalise.
- QlikView data-modelling beyond the "drag-and-drop" tutorial level.
- Writing reproducible synthetic data generators.

## Roadmap

- [ ] Migrate dashboards from QlikView → Qlik Sense.
- [ ] Expose a small REST API on top of the warehouse.
- [ ] Replace synthetic data with public-domain weather station data where it exists.
- [ ] ARIMA / Prophet forecasting on the consumption fact.
- [ ] Interactive map with region-level coloring.

## License

Proprietary. The repo is open for reading and reference; the code and data model aren't redistributable. For collaboration or licensing, reach out — yassirzahidi8@gmail.com.

## Project stats

- ~800 lines of SQL (schema + data generation).
- ~150 lines of QlikView script.
- 68 137 records.
- 131 months covered.
- 6 weeks of build time.
- 87-page final report (in French) — available on request.

— Yassir Zahidi · Rabat · [portfolio](https://y-zahidi.github.io) · [linkedin](https://www.linkedin.com/in/yassir-zahidi/)
