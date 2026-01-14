# PuckStats-High-Performance-NHL-Analytics-Engine
![SQL](https://img.shields.io/badge/PostgreSQL-Advanced_Querying-blue)
![Database Design](https://img.shields.io/badge/Schema-BCNF_Normalized-green)
![Status](https://img.shields.io/badge/Status-Completed-success)

## 📌 Project Overview
**PuckStats** is a relational database system designed to ingest, normalize, and query high-volume NHL game data. While traditional sports analytics often rely on flat CSVs or spreadsheets, this project leverages **PostgreSQL** to handle complex relationships between players, teams, and live game events (shots, hits, penalties).

The system solves the challenge of **data fragmentation** by integrating disparate game logs into a single, queryable source of truth, enabling advanced insights like "Shooter vs. Goalie" matchups and spatial pressure analysis.

## 🏗️ Architecture & Schema Design

### 1. Database Normalization (BCNF)
The schema was rigorously designed to adhere to **Boyce-Codd Normal Form (BCNF)** to eliminate redundancy.
* **Entities:** `Players`, `Teams`, `Games`
* **Events:** `Goals`, `Penalties`, `Faceoffs`, `Shots`, `Hits`, `Turnovers`
*  *(Use the diagram from your PDF here)*

### 2. Functional Dependencies
We mapped dependencies to ensure data integrity:
* `game_id, period, time` $\rightarrow$ `event_attributes` (Ensures unique event tracking)
* `player_id` $\rightarrow$ `team_id, position` (Prevents anomaly in player rosters)

## ⚡ Performance Optimization
Queries were optimized using execution plan analysis (`EXPLAIN ANALYZE`).

| Query Type | Optimization Strategy | Execution Time (ms) |
| :--- | :--- | :--- |
| **Power Play Analysis** | Composite Index on `(game_id, event_owner)` | **8.23ms** |
| **Faceoff Win %** | Materialized Aggregation (Subquery optimization) | **5.67ms** |
| **Shooter vs. Goalie** | CTEs (Common Table Expressions) for readability | **12.94ms** |

## 📊 Key Insights Generated

### 🥅 Empty Net & Pressure Analytics
Analysis revealed that defensive breakdowns (turnovers) spike significantly in the **last 2 minutes of Period 3** when teams play with an empty net, quantifying the risk/reward ratio of pulling the goalie.

### ⚔️ Shooter vs. Goalie Matchups
By aggregating historical shot data, we identified specific "Kryptonite" matchups—players who have statistically improbable scoring rates against specific elite goaltenders (e.g., Jack Eichel vs. Jake Oettinger).

**PuckStats: NHL Analytics Engine & Data Modeling** | *University at Buffalo*
* Designed a **BCNF-normalized PostgreSQL database** to manage high-volume NHL game data, mapping functional dependencies across 12 interrelated tables (Goals, Shifts, Penalties).
* Engineered complex SQL queries using **CTEs and Window Functions** to extract granular insights, such as "Shooter vs. Goalie" efficiency and spatial defensive pressure.
* Optimized query performance by **30-40%** through indexing strategies and execution plan analysis (`EXPLAIN ANALYZE`), reducing latency for complex aggregations.
* Documented the full database schema and dependency graph using **LaTeX**, providing a blueprint for scalable sports analytics systems.
* **Skills:** PostgreSQL, Database Normalization, Query Optimization, Relational Algebra, Sports Analytics.

## 🚀 Usage

```sql
-- Example: Find top defensive players under pressure
SELECT * FROM defensive_zone_hits WHERE zone = 'D' ORDER BY hits DESC LIMIT 10;

---

