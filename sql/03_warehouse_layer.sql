-- creating dim_product

CREATE TABLE warehouse.dim_product (
    product_sk          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_id             TEXT NOT NULL UNIQUE,
    product_name        TEXT,
    dept_id             TEXT,
    dept_name           TEXT,
    cat_id              TEXT,
    source_category     TEXT,
    nl_category         TEXT,
    nl_department       TEXT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- varifying the table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'warehouse'
AND table_name = 'dim_product'
ORDER BY ordinal_position;

-- now dim_date table 

CREATE TABLE warehouse.dim_date (
    date_sk                 INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_date               DATE NOT NULL UNIQUE,
    day_of_week             INTEGER,
    day_name                TEXT,
    is_weekend              BOOLEAN,
    week_of_year            INTEGER,
    month_number            INTEGER,
    month_name              TEXT,
    quarter                 INTEGER,
    year                    INTEGER,
    season                  TEXT,
    is_nl_holiday           BOOLEAN DEFAULT FALSE,
    holiday_name            TEXT,
    is_promotion_period     BOOLEAN DEFAULT FALSE,
    promotion_name          TEXT,
    d_column                TEXT,
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- varifying the table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'warehouse'
AND table_name = 'dim_date'
ORDER BY ordinal_position;

-- Now dim_store
CREATE TABLE warehouse.dim_store (
    store_sk                INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    store_id                TEXT NOT NULL UNIQUE,
    source_state            TEXT,
    nl_region               TEXT,
    nl_region_code          TEXT,
    distribution_zone       TEXT,
    city_cluster            TEXT,
    is_urban                BOOLEAN,
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- varifying the table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'warehouse'
AND table_name = 'dim_store'
ORDER BY ordinal_position;

--now dim_price

CREATE TABLE warehouse.dim_price (
    price_sk                INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    store_id                TEXT NOT NULL,
    item_id                 TEXT NOT NULL,
    wm_yr_wk                TEXT NOT NULL,
    sell_price              NUMERIC(10,2),
    price_change_pct        NUMERIC(8,4),
    is_promotional          BOOLEAN DEFAULT FALSE,
    price_tier              TEXT,
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (store_id, item_id, wm_yr_wk)
);

-- varifying the table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'warehouse'
AND table_name = 'dim_price'
ORDER BY ordinal_position;

-- Full dimension layer varification
SELECT table_name, COUNT(*) as column_count
FROM information_schema.columns
WHERE table_schema = 'warehouse'
GROUP BY table_name
ORDER BY table_name;
