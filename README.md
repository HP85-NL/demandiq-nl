# DemandIQ NL — Predictive Supply Chain Intelligence for Patel Mart B.V.

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?style=flat&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.9-3776AB?style=flat&logo=python&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=flat&logo=powerbi&logoColor=black)
![XGBoost](https://img.shields.io/badge/XGBoost-3.2.0-FF6600?style=flat)
![Prophet](https://img.shields.io/badge/Prophet-1.3.0-4285F4?style=flat)
![Status](https://img.shields.io/badge/Status-Complete-2ECC71?style=flat)

> **End-to-end predictive analytics pipeline** — from raw data ingestion to a boardroom-ready Power BI dashboard — built for a Dutch FMCG distributor using PostgreSQL, Python, and machine learning.

---

## 📊 Business Impact at a Glance

| Metric | Value |
|---|---|
| 💶 Excess inventory identified | **€2.37M** |
| 💰 Estimated annual holding cost saving | **€593K** |
| ⚠️ HIGH-risk SKU × Store combinations | **3,071 (13.2%)** |
| 📉 Forecast error reduction (RMSE) | **22.7% vs Prophet baseline** |
| 🏪 Revenue portfolio monitored | **€27.30M across 10 stores** |

---

## The Company — Patel Mart B.V.

**Patel Mart B.V.** is a Utrecht-based regional FMCG distributor supplying 10 retail locations across the Netherlands with €27.30M in annual revenue. The portfolio spans 3,000+ active SKUs across four categories — Voeding, Huishouden, Hobby & Vrije Tijd, and Persoonlijke Verzorging — serving retail partners across Utrecht, Zuid-Holland, Noord-Holland, and six other Dutch provinces.

Like most mid-size FMCG distributors, Patel Mart was managing inventory decisions manually — relying on spreadsheets, buyer intuition, and a blanket 14-day safety stock rule applied uniformly across all SKUs and locations. The result was predictable and costly: recurring stockouts on high-velocity Voeding SKUs, and excess safety stock on slow-moving categories tying up working capital across the warehouse network.

**DemandIQ NL** was built internally by the data analytics function to replace intuition with a demand-driven forecasting and inventory intelligence system — and to quantify the financial cost of the manual approach for the first time.

---

## The Business Problem

Two costly problems ran in parallel every single day at Patel Mart:

- **Stockouts** — a SKU runs out. The shelf is empty. The customer walks to a competitor. Revenue is lost permanently and supplier relationships are damaged.
- **Overstock** — too much inventory sits in the warehouse. Working capital is tied up. Products approaching expiry get discounted or written off entirely.

Both problems shared one root cause: **no reliable way to know which SKUs, in which stores, were about to fail — before they fail.**

A demand planner managing 3,000+ SKUs across 10 store locations cannot manually monitor every combination every day. They need a system that surfaces the right signal at the right time:

> *"These are the SKU × Store combinations you need to act on this week — here is the risk level, here is why, and here is what the data recommends."*

**The manual 14-day blanket rule was costing Patel Mart €2.37M in excess inventory value and €593K annually in holding costs.** DemandIQ NL was built to close that gap.

---

## What This Project Delivers

| Output | Business Value |
|---|---|
| Star schema data warehouse (37.2M fact rows) | Single source of truth for all demand and inventory decisions |
| XGBoost demand forecasting model | 22.7% lower forecast error — fewer emergency orders, better supplier planning |
| Stockout risk engine | 3,071 HIGH-risk SKU × Store combinations identified across 23,311 assessed |
| Business value quantification | €2.37M excess inventory | €593K annual holding cost saving identified |
| 5-page Power BI executive dashboard | €27.30M revenue portfolio monitored live across 10 Dutch stores |

---

## Dashboard
 
> 🔴 **[View the Live Dashboard →](https://app.powerbi.com/view?r=eyJrIjoiMmIyY2MxYjUtZjhkYS00MTcxLWIzYzMtM2Q0N2E4Mzk2YjRkIiwidCI6ImM2ZTU0OWIzLTVmNDUtNDAzMi1hYWU5LWQ0MjQ0ZGM1YjJjNCJ9)**

---

## Dashboard

### Home
*Navigation hub with project summary and KPI overview*

---

### Executive Summary
![Executive Summary](docs/screenshots/screenshot_executive_summary.png)
*€27.30M total revenue, 9M units, 740 SKUs across 10 stores. Revenue trend shows clear mid-year and Q4 seasonality aligned with Dutch retail calendar.*

---

### Stockout Risk
![Stockout Risk](docs/screenshots/screenshot_stockout_risk.png)
*13.17% of SKU × Store locations are HIGH risk. Voeding (Food) leads at 15.64% risk rate. SKU × Store detail table with conditional formatting enables immediate demand planner action.*

---

### Inventory Health
![Inventory Health](docs/screenshots/screenshot_inventory_health.png)
*Avg safety stock 5.47 units, reorder point 17.54 units, avg daily demand 2.43 units. Zuid-Holland carries the highest concentration of HIGH-risk scores. €593K annual saving identified vs manual 14-day rule.*

---

### Regional Performance
![Regional Performance](docs/screenshots/screenshot_regional_performance.png)
*Utrecht leads at €21.8M revenue — 80% of total portfolio. Regional revenue trend (2020–2025) shows diverging trajectories across Dutch provinces — critical input for store-level safety stock sizing.*

---

### Forecast vs Actual
![Forecast vs Actual](docs/screenshots/screenshot_forecast_vs_actual.png)
*XGBoost predicted vs actual demand by SKU. Avg actual: 31.91 units, avg predicted: 29.46 units, avg absolute error: 7.44 units. Model tracks demand direction accurately across the full forecast horizon.*

---

## Project Architecture

```
M5 Kaggle Dataset (Dutch FMCG adaptation — Patel Mart B.V.)
            │
            ▼
┌───────────────────────────┐
│      Staging Layer        │  Raw CSV → PostgreSQL
│         Phase 2           │  stg_calendar | stg_prices | stg_sales
│                           │  58.3M rows ingested via chunked streaming
└────────────┬──────────────┘
             │
             ▼
┌───────────────────────────┐
│      Warehouse Layer      │  Star schema transformation
│         Phase 3           │  dim_date | dim_product | dim_store
│                           │  dim_price | fact_sales → 37.2M rows
└────────────┬──────────────┘
             │
             ▼
┌───────────────────────────┐
│           EDA             │  Business-driven demand analysis
│         Phase 4           │  ABC classification, Dutch seasonality,
│                           │  category profiling, zero-sales detection
└────────────┬──────────────┘
             │
             ▼
┌───────────────────────────┐
│       Forecasting         │  Prophet vs XGBoost benchmarking
│         Phase 5           │  10 Class A SKUs, CA_3 Utrecht
│                           │  XGBoost wins: 22.7% RMSE improvement
└────────────┬──────────────┘
             │
             ▼
┌───────────────────────────┐
│     Inventory Engine      │  Statistical safety stock (Z × σ × √L)
│         Phase 6           │  Composite risk score 0–100
│                           │  23,311 rows at SKU × Store grain
└────────────┬──────────────┘
             │
             ▼
┌───────────────────────────┐
│   Business Value Layer    │  €2.37M excess inventory quantified
│   05_business_value.sql   │  €593K annual holding cost saving
│                           │  Manual 14-day rule vs statistical model
└────────────┬──────────────┘
             │
             ▼
┌───────────────────────────┐
│    Power BI Dashboard     │  5-page executive dashboard
│         Phase 7           │  Connected via PostgreSQL analytical views
│                           │  Live data — no flat file exports
└───────────────────────────┘
```

---

## Dataset

**Source:** [M5 Forecasting Competition](https://www.kaggle.com/competitions/m5-forecasting-accuracy) — a real-world retail demand benchmark used across academic research and industry supply chain modelling.

**Dutch FMCG Adaptation (Patel Mart B.V. context):**

The original US Walmart dataset was transformed to reflect a Dutch FMCG distributor operating from Utrecht:

- Product categories mapped to Dutch equivalents: `Voeding`, `Huishouden`, `Hobby & Vrije Tijd`, `Persoonlijke Verzorging`
- Store locations mapped to Dutch provinces and cities: Utrecht, Zuid-Holland, Noord-Holland, Drenthe, Groningen, Zeeland, Gelderland, Overijssel, Noord-Brabant, Friesland
- Dates aligned to the Dutch retail calendar with public holidays applied: Koningsdag, Bevrijdingsdag, Sinterklaas, Kerst
- Business context set as a current operational scenario at Patel Mart — not a historical US retail exercise

This localisation was deliberate: the goal was to build something meaningful to a Dutch hiring manager or supply chain stakeholder, not just execute a tutorial on a borrowed dataset.

---

## Key Findings

### Demand Structure
- **Voeding (Food)** carries the highest stockout risk at **15.64%** — the top inventory priority for Patel Mart demand planners
- **997 Class A SKUs** drive 80% of total revenue — Pareto principle confirmed in live demand data
- **Dutch holidays suppress demand by 6.4%** on average — critical input for safety stock recalibration around Koningsdag and Sinterklaas
- **Utrecht** is the highest-revenue region at **€21.8M** — the anchor location for the forecasting pilot

### Forecasting Results (Phase 5)

XGBoost benchmarked against Prophet on 10 Class A smooth-demand SKUs from Patel Mart store CA_3 Utrecht:

| Metric | Result |
|---|---|
| SKUs where XGBoost outperformed Prophet | **10 out of 10** |
| Average RMSE improvement over Prophet | **22.7%** |
| Average MAPE improvement over Prophet | **21.3%** |
| Best individual gain (MAPE) | FOODS_3_389: 33.6% → 9.9% |
| Largest absolute improvement (MAPE) | FOODS_3_681: 124.3% → 42.8% |

**Why XGBoost wins on this data:** Prophet assumes additive seasonality — it works well when demand has stable, repeating cycles. On smooth, high-frequency FMCG data, that assumption inflates error. XGBoost captures non-linear interactions between price, holidays, and category demand that Prophet cannot model. The data validated this — not just the theory.

### Inventory Risk Engine (Phase 6)

| Metric | Value |
|---|---|
| Total SKU × Store combinations assessed | 23,311 |
| HIGH risk combinations (score ≥ 50) | **3,071 (13.2%)** |
| Portfolio showing some risk level (≥ LOW) | **657 SKUs across 87% of locations** |
| Safety stock formula | Z × σ × √L — Z = 1.65 (95% service level) |
| Reorder point formula | d̄ × L + Safety Stock |
| Avg safety stock across portfolio | **5.47 units** |
| Avg reorder point across portfolio | **17.54 units** |

### Business Value Quantification

| Metric | Value |
|---|---|
| Manual safety stock rule | Flat 14-day buffer — uniform across all SKUs |
| Optimised safety stock | Z × σ × √L — calibrated per SKU demand variability |
| Total excess inventory identified | **€2.37M** |
| Annual holding cost saving (@ 25% rate) | **€593K** |
| SKU × Store combinations assessed | 23,311 |

> The 25% holding cost rate is an FMCG industry standard accounting for storage, capital cost, spoilage, and insurance. Replacing the manual 14-day blanket rule with statistical safety stock modelling is the single highest-ROI change Patel Mart can make to its inventory policy.

---

## What I Learned

### The hardest engineering problem: 58 million rows, one machine

The M5 sales dataset arrives as a wide-format CSV — 30,490 rows, each with 1,913 day-columns. PostgreSQL has a hard column limit of 1,600. The naive approach fails immediately.

The solution required rethinking the problem entirely: stream the file in chunks, melt each chunk from wide to long format in memory, and write to PostgreSQL incrementally. This turned a 30,490-row wide file into 58.3M tidy rows — one row per item, store, and date — without ever loading the full dataset into memory at once.

Two lessons: database constraints are not obstacles — they are signals that the data model needs to change. And production-grade pipelines are defined by what happens when the naive approach fails, not by what works on clean sample data.

### Why Prophet failed — and what that means for model selection

Prophet is a well-regarded model. On Dutch FMCG smooth demand data, it lost to XGBoost on all 10 SKUs. The reason is specific: Prophet's additive decomposition assumes stable, repeating seasonal cycles. FMCG demand at SKU level is shaped by price promotions, localised events, and store-level effects that do not repeat cleanly. XGBoost, given lagged demand features and calendar variables, captures these interactions without imposing structure the data does not support.

The lesson: model selection is a data question, not a preference. Run the benchmark. Let the numbers decide.

### Risk scores are only as good as their calibration

The first version of the stockout risk engine flagged 6 HIGH-risk SKUs from 23,311 combinations. That number was clearly wrong. The formula was correct — the threshold was set by intuition rather than by looking at the actual score distribution. Investigating the distribution, recalibrating the threshold, and validating against store volume rankings changed the output from 6 to 3,071.

The lesson: every model output needs a sanity check against something real. If a result looks too clean, it is almost certainly wrong.

### Business value must be calculated, not assumed

The inventory engine was complete at Phase 6 — risk scores were accurate, safety stock formulas were correct. But "accurate" is not the same as "impactful." The business value calculation (Phase 7 SQL) was the step that turned a technically correct model into a business case: €2.37M in excess inventory, €593K in annual savings. Without that number, the project tells a technical story. With it, it tells a business story. That distinction matters enormously in a Dutch corporate environment.

---

## Repository Structure

```
demandiq-nl/
│
├── README.md
│
├── sql/
│   ├── 01_star_schema.sql                  # Schema design + table definitions
│   ├── 02_staging_layer.sql                # Staging table DDL
│   ├── 03_warehouse_layer.sql              # Dimension + fact table DDL
│   ├── 05_business_value_calculation.sql   # €2.37M excess inventory | €593K saving
│   └── 07_powerbi_views.sql                # 5 analytical views for Power BI
│
├── notebooks/
│   ├── 01_data_loading_staging.ipynb       # Staging ETL pipeline
│   ├── 02_warehouse_transformation.ipynb   # Star schema loading
│   ├── 03_eda.ipynb                        # Demand analysis + ABC classification
│   ├── 04_forecasting.ipynb                # Prophet vs XGBoost benchmarking
│   └── 05_inventory_engine.ipynb           # Risk scoring engine
│
├── powerbi/
│   └── DemandIQ_NL.pbix                    # 5-page executive dashboard
│
├── docs/
│   └── screenshots/                        # Dashboard page screenshots
│
└── data/
    └── README.md                           # M5 dataset download instructions
```

---

## Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| Database | PostgreSQL 15 | Staging, warehouse, analytical views |
| Data Engineering | Python, pandas, psycopg2, SQLAlchemy | ETL pipeline, chunked loading |
| Forecasting | XGBoost 3.2.0, Prophet 1.3.0 | Demand prediction, model benchmarking |
| Dashboard | Power BI Desktop + Npgsql | Executive reporting layer |
| Environment | Jupyter Notebook | Interactive development |

---

## How to Run Locally

### Prerequisites
- PostgreSQL 15+
- Python 3.9+
- Jupyter Notebook
- Power BI Desktop (Windows)

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/demandiq-nl.git
cd demandiq-nl

# 2. Install Python dependencies
pip install pandas numpy sqlalchemy psycopg2-binary prophet xgboost jupyter tqdm

# 3. Download the M5 dataset from Kaggle
# https://www.kaggle.com/competitions/m5-forecasting-accuracy
# Place the three CSV files in: data/raw/

# 4. Create PostgreSQL database
createdb demandiq_nl

# 5. Run SQL schema files in order
psql -d demandiq_nl -f sql/01_star_schema.sql
psql -d demandiq_nl -f sql/02_staging_layer.sql
psql -d demandiq_nl -f sql/03_warehouse_layer.sql
psql -d demandiq_nl -f sql/07_powerbi_views.sql

# 6. Run notebooks in order 01 → 05
jupyter notebook
```

**Power BI:** Open `DemandIQ_NL.pbix` and update the PostgreSQL server connection to your local `demandiq_nl` database.

---

## About

I am a data analyst at Patel Mart B.V. with hands-on experience across the full analytics stack — SQL, Python, data modelling, machine learning, and BI reporting. DemandIQ NL is the internal system I built to replace manual inventory decisions with data-driven intelligence.

Most data projects stop at the analysis. This one does not. The pipeline goes from raw CSV ingestion through a production-grade star schema, into a benchmarked forecasting model, into a risk engine that produces actionable output at SKU × Store grain, and finally into a dashboard that a supply chain manager can open on Monday morning and know exactly where to focus. The business value layer closes the loop — translating model output into €2.37M of identifiable excess inventory and €593K in annual savings.

The Dutch FMCG market is where I want to apply this thinking at scale. Companies like Unilever, Albert Heijn, and Jumbo operate at a level where better demand forecasting and smarter inventory decisions translate directly into revenue recovery, reduced waste, and stronger supplier relationships. That is the impact I want to work on.

If you are hiring for a role where data engineering, analytical thinking, and business context need to sit in the same person — I would like to talk.

📧 your.email@example.com
💼 [LinkedIn](https://linkedin.com/in/YOUR_PROFILE)

---

*Dataset: M5 Forecasting Competition (Kaggle). Transformed and adapted for Dutch FMCG market context. Company name and business scenario are illustrative.*
