#staging table_1

CREATE TABLE staging.stg_sales (
    id          TEXT,
    item_id     TEXT,
    dept_id     TEXT,
    cat_id      TEXT,
    store_id    TEXT,
    state_id    TEXT,
    raw_data    JSONB
);

#staging table_2
CREATE TABLE staging.stg_calendar (
    date            TEXT,
    wm_yr_wk        TEXT,
    weekday         TEXT,
    wday            TEXT,
    month           TEXT,
    year            TEXT,
    d               TEXT,
    event_name_1    TEXT,
    event_type_1    TEXT,
    event_name_2    TEXT,
    event_type_2    TEXT,
    snap_CA         TEXT,
    snap_TX         TEXT,
    snap_WI         TEXT
);

#staging table_3

CREATE TABLE staging.stg_prices (
    store_id    TEXT,
    item_id     TEXT,
    wm_yr_wk    TEXT,
    sell_price  TEXT
);

SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'staging'
AND table_name = 'stg_sales'
ORDER BY ordinal_position;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'staging'
ORDER BY table_name;