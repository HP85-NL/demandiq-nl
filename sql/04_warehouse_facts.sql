--creating the fact tables
CREATE TABLE warehouse.fact_sales (
    sales_sk            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_sk          INTEGER NOT NULL REFERENCES warehouse.dim_product(product_sk),
    date_sk             INTEGER NOT NULL REFERENCES warehouse.dim_date(date_sk),
    store_sk            INTEGER NOT NULL REFERENCES warehouse.dim_store(store_sk),
    price_sk            INTEGER REFERENCES warehouse.dim_price(price_sk),
    units_sold          INTEGER NOT NULL DEFAULT 0,
    revenue             NUMERIC(12,2),
    is_zero_sales       BOOLEAN GENERATED ALWAYS AS (units_sold = 0) STORED,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (product_sk, date_sk, store_sk)
);

--varifying the table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'warehouse'
AND table_name = 'fact_sales'
ORDER BY ordinal_position;

SELECT column_name, data_type, is_nullable, column_default, is_generated
FROM information_schema.columns
WHERE table_schema = 'warehouse'
AND table_name = 'fact_sales'
ORDER BY ordinal_position;


-- now creating fact inventory table 
CREATE TABLE warehouse.fact_inventory (
    inventory_sk                INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_sk                  INTEGER NOT NULL REFERENCES warehouse.dim_product(product_sk),
    store_sk                    INTEGER NOT NULL REFERENCES warehouse.dim_store(store_sk),
    date_sk                     INTEGER NOT NULL REFERENCES warehouse.dim_date(date_sk),
    forecasted_demand_4wk       NUMERIC(10,2),
    avg_daily_demand            NUMERIC(10,4),
    demand_std_dev              NUMERIC(10,4),
    lead_time_days              INTEGER DEFAULT 7,
    service_level_pct           NUMERIC(5,2) DEFAULT 95.00,
    safety_stock                NUMERIC(10,2),
    reorder_point               NUMERIC(10,2),
    current_stock               NUMERIC(10,2),
    days_of_stock_remaining     NUMERIC(8,2),
    recommended_order_qty       NUMERIC(10,2),
    stockout_risk_score         NUMERIC(5,4),
    risk_category               TEXT,
    model_version               TEXT,
    scored_at                   TIMESTAMP,
    created_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (product_sk, store_sk, date_sk)
);

-- varifying the table

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'warehouse'
AND table_name = 'fact_inventory'
ORDER BY ordinal_position;

--full varification

SELECT table_name, COUNT(*) as column_count
FROM information_schema.columns
WHERE table_schema = 'warehouse'
GROUP BY table_name
ORDER BY table_name;


SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
    ON tc.constraint_name = ccu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_schema = 'warehouse'
ORDER BY tc.table_name;