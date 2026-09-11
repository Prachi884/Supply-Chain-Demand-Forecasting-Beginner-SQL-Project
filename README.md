# Supply Chain Demand Forecasting — Beginner SQL Project

A beginner-level SQL project analyzing a retail supply chain dataset
modeled on **Walmart-style multi-store, multi-category operations** —
the kind of company that runs large-scale demand forecasting to decide
what to stock, where, and when.

> This is a portfolio/learning project. The dataset is synthetically
> generated, but the schema and business questions mirror how a real
> retail supply chain analyst starts working with SQL — pure
> `SELECT` / `JOIN` / `GROUP BY` fundamentals, no advanced SQL required.

👉 **[Read the Full Business Findings & Report (FINDINGS.md)](./FINDINGS.md)**

---

## 1. Business context

Large retailers constantly wrestle with one core supply-chain question:
**"How much of each product will customers want, at each store, and do
we have enough of it — without overstocking?"**

Getting this wrong shows up as:
- **Stockouts** — lost sales when demand exceeds available inventory
- **Overstock** — wasted shelf space, markdowns, tied-up capital
- **Poor promotion planning** — running promos without knowing their real demand lift
- **Seasonal blind spots** — under-ordering Electronics/Toys before the holidays
- **Supplier risk** — over-reliance on one supplier

This project answers 10 of the most common versions of that question,
using only beginner SQL.

---

## 2. Repo structure

```
supply-chain-demand-forecasting/
├── README.md
├── FINDINGS.md                       -- the project's outcome/story, told in numbers
├── LICENSE
├── .gitignore
├── sql/
│   ├── schema.sql                    -- table definitions (DDL)
│   └── analysis_and_forecasting.sql  -- 10 beginner-level business questions
├── data/
│   ├── stores.csv
│   ├── products.csv
│   └── daily_sales.csv
└── images/
    └── query 1.jpeg ... query 10.jpeg  -- screenshots of each query running
```

**Start with [`FINDINGS.md`](FINDINGS.md)** if you want the story
first — it walks through what each of the 10 queries actually found
before you look at the SQL.

---

## 3. Dataset

Three CSV tables, ~100,000 total records spanning **Jan 2023 – Dec 2024**
across **20 stores** and **150 products**.

### `stores.csv` (20 rows) — dimension table
| Column | Description |
|---|---|
| `store_id` | Primary key |
| `store_name` | Store identifier |
| `region` | West / South / Midwest / Northeast |
| `state` | US state |
| `store_type` | Supercenter / Neighborhood Market / Discount Store |
| `store_size_sqft` | Store footprint |

### `products.csv` (150 rows) — dimension table
| Column | Description |
|---|---|
| `product_id` | Primary key |
| `product_name` | Product name |
| `category` | Grocery, Electronics, Apparel, Home & Garden, Health & Wellness, Toys |
| `sub_category` | e.g. Snacks, TVs, Men's Wear |
| `unit_price` | Regular selling price |
| `unit_cost` | Cost to the retailer |
| `supplier_name` | Supplying vendor |

### `daily_sales.csv` (~100,000 rows) — fact table
| Column | Description |
|---|---|
| `sale_id` | Primary key |
| `sale_date` | Date of the record |
| `store_id` | FK → stores |
| `product_id` | FK → products |
| `units_demanded` | Customer demand that day (the forecasting target) |
| `units_sold` | Units actually sold (capped by available inventory) |
| `inventory_on_hand` | Stock available at the start of the day |
| `units_ordered` | Replenishment order placed to the supplier |
| `unit_price` | Selling price that day (reflects promo discount if applied) |
| `promotion_flag` | 1 = on promotion |
| `stockout_flag` | 1 = demand exceeded available inventory that day |
| `lead_time_days` | Supplier lead time for that order |

**Entity relationship:** `stores (1) ──< daily_sales >── (1) products`
— `daily_sales` is the fact table; `stores` and `products` are dimension
tables joined on `store_id` and `product_id`.

---

## 4. How to run this project

### SQLite (fastest, no server needed)
```bash
sqlite3 supply_chain.db < sql/schema.sql

sqlite3 supply_chain.db
.mode csv
.import --skip 1 data/stores.csv stores
.import --skip 1 data/products.csv products
.import --skip 1 data/daily_sales.csv daily_sales
.read sql/analysis_and_forecasting.sql
```

### MySQL or PostgreSQL
The schema uses ANSI-standard types and works with minor tweaks:
- Replace `INTEGER PRIMARY KEY` with `INT AUTO_INCREMENT PRIMARY KEY` (MySQL)
  or `SERIAL PRIMARY KEY` (Postgres).
- Load data with `LOAD DATA INFILE` (MySQL) or `\copy` (Postgres) instead
  of the SQLite `.import` command.

---

## 5. Query catalog — business question → SQL concept

All 10 queries use only beginner fundamentals: `SELECT`, `WHERE`,
`JOIN`, `GROUP BY`, `ORDER BY`, `LIMIT`, `BETWEEN`, and the aggregate
functions `COUNT`, `SUM`, `AVG`. No subqueries, CTEs, or window
functions anywhere in this project.

| # | Business question | SQL concepts |
|---|---|---|
| Q1 | Which product categories generate the most total revenue? | `JOIN`, `GROUP BY`, `SUM` |
| Q2 | What are our top 10 best-selling products by units sold? | `JOIN`, `GROUP BY`, `ORDER BY`, `LIMIT` |
| Q3 | How many stores do we have in each region? | `GROUP BY`, `COUNT` |
| Q4 | Which 10 stores experienced the most stockout days? | `WHERE`, `JOIN`, `GROUP BY` |
| Q5 | What is the average selling price per category? | `GROUP BY`, `AVG` |
| Q6 | How many transactions happened during promotions vs. regular price? | `GROUP BY`, `COUNT`, `SUM` |
| Q7 | What did demand look like during the 2023 holiday season? | `WHERE`, `BETWEEN` |
| Q8 | Which suppliers do we rely on most? | `GROUP BY`, `COUNT` |
| Q9 | What is the total revenue and profit generated by each region? | 3-table `JOIN` |
| Q10 | Which 10 products had the highest number of stockout days? | `JOIN`, `GROUP BY`, `ORDER BY`, `LIMIT` |

All results in `FINDINGS.md` were generated by actually running these
queries against the included dataset — nothing there is hand-typed.

---

## 6. Screenshots — queries in action

Proof that every query actually ran, with real output, against the
dataset in this repo:

| Query | Screenshot |
|---|---|
| Q1 — Revenue by category | ![Q1](./images/query%201.jpeg) |
| Q2 — Top 10 best-selling products | ![Q2](./images/query%202.jpeg) |
| Q3 — Store count by region | ![Q3](./images/query%203.jpeg) |
| Q4 — Top 10 stockout stores | ![Q4](./images/query%204.jpeg) |
| Q5 — Average price by category | ![Q5](./images/query%205.jpeg) |
| Q6 — Promo vs. regular transactions | ![Q6](./images/query%206.jpeg) |
| Q7 — Holiday season demand | ![Q7](./images/query%207.jpeg) |
| Q8 — Top suppliers | ![Q8](./images/query%208.jpeg) |
| Q9 — Revenue & profit by region | ![Q9](./images/query%209.jpeg) |
| Q10 — Top 10 stockout products | ![Q10](./images/query%2010.jpeg) |

---

## 7. Sample findings

Full breakdown with all the numbers is in **[FINDINGS.md](FINDINGS.md)**.
The short version:

- **Electronics drives the most revenue** (~$48.7M, 43% of total) despite
  lower unit volume than Grocery, due to its much higher price point.
- **Electronics products dominate the stockout list** — 8 of the top 10
  products by stockout-day count are Electronics.
- **Two Midwest stores rank among the worst for stockouts**, and the
  Midwest overall trails every other region on both revenue and profit.

---

## 8. Possible extensions
- Add a `promotions.csv` table with promo start/end dates and depth.
- Move up to intermediate SQL: window functions for moving averages,
  CTEs for multi-step analysis, `RANK()` for store rankings within region.
- Visualize the query outputs in Tableau/Power BI/Excel.

---

## 9. Tech stack
SQL (SQLite dialect, portable to MySQL/PostgreSQL). No other dependencies
required to explore this project.

---

*This project is for educational/portfolio purposes. Company names
(e.g. Walmart) are referenced only as real-world context for the type
of business problem being modeled; the data itself is entirely synthetic.*
