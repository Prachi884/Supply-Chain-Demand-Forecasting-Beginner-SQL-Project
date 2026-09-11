-- ============================================================
-- Supply Chain Demand Forecasting — Schema
-- 3 tables: stores (dim), products (dim), daily_sales (fact)
-- Works in SQLite, MySQL, and PostgreSQL with minor type tweaks.
-- ============================================================

DROP TABLE IF EXISTS daily_sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS stores;

CREATE TABLE stores (
    store_id        INTEGER PRIMARY KEY,
    store_name      TEXT NOT NULL,
    region          TEXT NOT NULL,
    state           TEXT NOT NULL,
    store_type      TEXT NOT NULL,      -- Supercenter / Neighborhood Market / Discount Store
    store_size_sqft INTEGER NOT NULL
);

CREATE TABLE products (
    product_id     INTEGER PRIMARY KEY,
    product_name   TEXT NOT NULL,
    category       TEXT NOT NULL,
    sub_category   TEXT NOT NULL,
    unit_price     REAL NOT NULL,
    unit_cost      REAL NOT NULL,
    supplier_name  TEXT NOT NULL
);

CREATE TABLE daily_sales (
    sale_id            INTEGER PRIMARY KEY,
    sale_date          TEXT NOT NULL,      -- YYYY-MM-DD
    store_id           INTEGER NOT NULL,
    product_id         INTEGER NOT NULL,
    units_demanded     INTEGER NOT NULL,   -- customer demand that day (forecast target)
    units_sold         INTEGER NOT NULL,   -- actual units sold (<= inventory available)
    inventory_on_hand  INTEGER NOT NULL,   -- stock available at start of day
    units_ordered      INTEGER NOT NULL,   -- replenishment order placed to supplier
    unit_price         REAL NOT NULL,      -- selling price that day (post-promo if applicable)
    promotion_flag     INTEGER NOT NULL,   -- 1 = on promotion, 0 = regular price
    stockout_flag      INTEGER NOT NULL,   -- 1 = demand exceeded available inventory
    lead_time_days     INTEGER NOT NULL,   -- supplier lead time for that order

    FOREIGN KEY (store_id)   REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE INDEX idx_sales_date    ON daily_sales(sale_date);
CREATE INDEX idx_sales_store   ON daily_sales(store_id);
CREATE INDEX idx_sales_product ON daily_sales(product_id);
