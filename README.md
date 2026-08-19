# Water Stress Morocco Analytics

> A data-warehouse and BI case study covering Morocco’s 12 regions, 46 cities, and 131 months of synthetic water-stress records.

![Portfolio case study](https://img.shields.io/badge/status-portfolio_case_study-5cf2c1?labelColor=0a0e14)
![Data boundary](https://img.shields.io/badge/data-synthetic_|_validated-5cf2c1?labelColor=0a0e14)
![Warehouse](https://img.shields.io/badge/warehouse-MySQL_8.0-5cf2c1?labelColor=0a0e14)
![BI](https://img.shields.io/badge/BI-QlikView-5cf2c1?labelColor=0a0e14)

## Case file

This project models water-stress reporting for Morocco as a small analytical platform: deterministic records are generated, loaded into a MySQL star schema, and exposed through QlikView dashboards. The data is **synthetic**. It is not an official hydrological dataset and must not be interpreted as one.

The purpose is to demonstrate data modeling, reproducible generation, BI data preparation, and transparent validation—not to publish a claim about current national water conditions.

## Scope

| Dimension | Project scope |
|:--|:--|
| Geography | 12 regions and 46 cities. |
| Time | 131 monthly periods from January 2015 to November 2025. |
| Domains | Agriculture, industry, domestic use, and services. |
| Warehouse | Seven-table MySQL star schema with foreign keys and checks. |
| Records | Approximately 68,000 generated and dependent rows. |
| Reporting | QlikView dashboards for national, regional, and city-level views. |

## Architecture

```text
Synthetic source model
        │  deterministic Python generation
        ▼
MySQL warehouse / InnoDB
        │  star schema + constraints
        ▼
ODBC data connection
        │
QlikView dashboards and KPI views
```

The source model, warehouse, and reporting layer are kept separate so that generated records can be reproduced and dashboard logic can be inspected independently.

## Evidence

| Artifact | What it demonstrates |
|:--|:--|
| [`docs/architecture.md`](docs/architecture.md) | Three-tier system design and data movement. |
| [`docs/data_dictionary.md`](docs/data_dictionary.md) | Warehouse fields, relationships, and meanings. |
| [`screenshots/mysql_tables_overview.png`](screenshots/mysql_tables_overview.png) | Warehouse structure and table organization. |
| [`screenshots/qlikview_data_model.png`](screenshots/qlikview_data_model.png) | BI data-model preparation. |
| [`screenshots/dashboard_national_2020.png`](screenshots/dashboard_national_2020.png) | National reporting view. |
| [`screenshots/dashboard_cities_2022.png`](screenshots/dashboard_cities_2022.png) | City-level drill-down view. |

## Technical problem: synthetic keys

Multiple fact tables sharing city and month dimensions can cause QlikView to generate synthetic keys. The project addresses this with an explicit link-table pattern so that associations remain predictable and dashboard aggregations are easier to reason about.

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
```

The result is a cleaner association model with more predictable aggregations.

## Data-generation boundary

The generator combines a long-term trend, a seasonal component, and deterministic variation. External references are used only as aggregate plausibility checks; they are not copied into the generated records and do not turn the project into an official dataset.

For future validation work, the relevant reference families are [FAO AQUASTAT](https://www.fao.org/aquastat/en/) and the [World Bank water indicators](https://data.worldbank.org/topic/water). Any future percentage-comparison claim should state the exact indicator, period, transformation, and comparison method.

## What this proves

This project demonstrates star-schema design, reproducible synthetic-data generation, BI modeling beyond drag-and-drop configuration, and disciplined communication of data provenance. The strongest evidence is not the simulated number itself; it is the separation between generation, warehouse constraints, dashboard associations, and validation references.

## Documentation

- [`docs/architecture.md`](docs/architecture.md) — system design.
- [`docs/data_dictionary.md`](docs/data_dictionary.md) — schema reference.
- [`code-snippets/`](code-snippets/) — selected SQL and QlikView extracts.

## Roadmap

- [ ] Migrate dashboards from QlikView to Qlik Sense.
- [ ] Expose a small read-only API over the warehouse.
- [ ] Add public-domain observation data where licensing and provenance permit.
- [ ] Compare forecasting approaches on the consumption fact table.
- [ ] Add an interactive regional map with explicit data-source labeling.

## License and data policy

The repository is a portfolio case study. Generated records and project materials are provided for review and are not presented as official public statistics. See [LICENSE](LICENSE) for the repository terms.

## About

I am **Yassir Zahidi**, a security engineering student focused on data systems, detection, validation, and practical engineering.

- Portfolio: <https://y-zahidi.github.io>
- GitHub: <https://github.com/y-zahidi>
- LinkedIn: <https://www.linkedin.com/in/yassir-zahidi/>
