-- View 1: Executive Summary
CREATE OR REPLACE VIEW warehouse.vw_executive_summary AS
SELECT
    dd.year,
    dd.month_number,
    dd.month_name,
    dd.week_of_year,
    ds.nl_region,
    ds.distribution_zone,
    dp.nl_category,
    dp.nl_department,
    SUM(fs.units_sold) AS total_units,
    SUM(fs.units_sold * dpr.sell_price) AS total_revenue,
    COUNT(DISTINCT dp.item_id) AS distinct_skus,
    COUNT(DISTINCT ds.store_id) AS distinct_stores
FROM warehouse.fact_sales fs
JOIN warehouse.dim_date dd ON dd.date_sk = fs.date_sk
JOIN warehouse.dim_store ds ON ds.store_sk = fs.store_sk
JOIN warehouse.dim_product dp ON dp.product_sk = fs.product_sk
JOIN staging.stg_calendar sc ON sc.date::date = dd.full_date
JOIN warehouse.dim_price dpr
    ON dpr.wm_yr_wk = sc.wm_yr_wk
    AND dpr.item_id = dp.item_id
    AND dpr.store_id = ds.store_id
WHERE fs.is_zero_sales = FALSE
GROUP BY
    dd.year, dd.month_number, dd.month_name, dd.week_of_year,
    ds.nl_region, ds.distribution_zone,
    dp.nl_category, dp.nl_department;


-- View 2: Forecast vs Actual



-- View 3: Stockout Risk
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'warehouse'
AND table_name = 'fact_inventory'
ORDER BY ordinal_position;


CREATE OR REPLACE VIEW warehouse.vw_stockout_risk AS
SELECT
    ds.store_id,
    fi.sku_id,
    ds.nl_region,
    ds.distribution_zone,
    ds.city_cluster,
    dp.nl_category,
    dp.nl_department,
    dp.product_name,
    fi.avg_daily_demand,
    fi.std_daily_demand,
    fi.lead_time_days,
    fi.safety_stock,
    fi.reorder_point,
    fi.max_stock,
    fi.stockout_risk_score,
    fi.risk_tier
FROM warehouse.fact_inventory fi
JOIN warehouse.dim_store ds ON ds.store_sk = fi.store_sk
JOIN warehouse.dim_product dp ON dp.item_id = fi.sku_id::text;


DROP VIEW IF EXISTS warehouse.vw_stockout_risk;

CREATE OR REPLACE VIEW warehouse.vw_stockout_risk AS
SELECT
    ds.store_id,
    dp.item_id,
    ds.nl_region,
    ds.distribution_zone,
    ds.city_cluster,
    dp.nl_category,
    dp.nl_department,
    dp.product_name,
    fi.avg_daily_demand,
    fi.std_daily_demand,
    fi.lead_time_days,
    fi.safety_stock,
    fi.reorder_point,
    fi.max_stock,
    fi.stockout_risk_score,
    fi.risk_tier
FROM warehouse.fact_inventory fi
JOIN warehouse.dim_store ds ON ds.store_sk = fi.store_sk
JOIN warehouse.dim_product dp ON dp.product_sk = fi.sku_id;

SELECT COUNT(*) FROM warehouse.vw_stockout_risk;


-- View 4: Inventory Health
CREATE OR REPLACE VIEW warehouse.vw_inventory_health AS
SELECT
    ds.nl_region,
    ds.distribution_zone,
    dp.nl_category,
    dp.nl_department,
    fi.abc_class,
    fi.risk_tier,
    COUNT(*) AS total_skus,
    ROUND(AVG(fi.avg_daily_demand), 2) AS avg_daily_demand,
    ROUND(AVG(fi.safety_stock), 2) AS avg_safety_stock,
    ROUND(AVG(fi.reorder_point), 2) AS avg_reorder_point,
    ROUND(AVG(fi.stockout_risk_score), 2) AS avg_risk_score,
    SUM(CASE WHEN fi.risk_tier = 'Critical' THEN 1 ELSE 0 END) AS critical_skus,
    SUM(CASE WHEN fi.risk_tier = 'High' THEN 1 ELSE 0 END) AS high_risk_skus,
    SUM(CASE WHEN fi.risk_tier = 'Medium' THEN 1 ELSE 0 END) AS medium_risk_skus,
    SUM(CASE WHEN fi.risk_tier = 'Low' THEN 1 ELSE 0 END) AS low_risk_skus
FROM warehouse.fact_inventory fi
JOIN warehouse.dim_store ds ON ds.store_sk = fi.store_sk
JOIN warehouse.dim_product dp ON dp.product_sk = fi.sku_id
GROUP BY
    ds.nl_region,
    ds.distribution_zone,
    dp.nl_category,
    dp.nl_department,
    fi.abc_class,
    fi.risk_tier;

-- View 5: Regional Performance
CREATE OR REPLACE VIEW warehouse.vw_regional_performance AS
SELECT
    dd.year,
    dd.month_number,
    dd.month_name,
    dd.quarter,
    ds.store_id,
    ds.nl_region,
    ds.distribution_zone,
    ds.city_cluster,
    ds.is_urban,
    dp.nl_category,
    SUM(fs.units_sold) AS total_units,
    SUM(fs.units_sold * dpr.sell_price) AS total_revenue,
    COUNT(DISTINCT dp.item_id) AS distinct_skus,
    ROUND(AVG(fs.units_sold), 2) AS avg_daily_units
FROM warehouse.fact_sales fs
JOIN warehouse.dim_date dd ON dd.date_sk = fs.date_sk
JOIN warehouse.dim_store ds ON ds.store_sk = fs.store_sk
JOIN warehouse.dim_product dp ON dp.product_sk = fs.product_sk
JOIN staging.stg_calendar sc ON sc.date::date = dd.full_date
JOIN warehouse.dim_price dpr
    ON dpr.wm_yr_wk = sc.wm_yr_wk
    AND dpr.item_id = dp.item_id
    AND dpr.store_id = ds.store_id
WHERE fs.is_zero_sales = FALSE
GROUP BY
    dd.year, dd.month_number, dd.month_name, dd.quarter,
    ds.store_id, ds.nl_region, ds.distribution_zone,
    ds.city_cluster, ds.is_urban,
    dp.nl_category;
SELECT * FROM warehouse.vw_regional_performance LIMIT 5;


SELECT DISTINCT risk_tier, COUNT(*) 
FROM warehouse.fact_inventory
GROUP BY risk_tier;

DROP VIEW warehouse.vw_inventory_health;

CREATE OR REPLACE VIEW warehouse.vw_inventory_health AS
SELECT
    ds.nl_region,
    ds.distribution_zone,
    dp.nl_category,
    dp.nl_department,
    fi.abc_class,
    fi.risk_tier,
    COUNT(*) AS total_skus,
    ROUND(AVG(fi.avg_daily_demand), 2) AS avg_daily_demand,
    ROUND(AVG(fi.safety_stock), 2) AS avg_safety_stock,
    ROUND(AVG(fi.reorder_point), 2) AS avg_reorder_point,
    ROUND(AVG(fi.stockout_risk_score), 2) AS avg_risk_score,
    SUM(CASE WHEN fi.risk_tier = 'High' THEN 1 ELSE 0 END) AS high_risk_skus,
    SUM(CASE WHEN fi.risk_tier = 'Medium' THEN 1 ELSE 0 END) AS medium_risk_skus,
    SUM(CASE WHEN fi.risk_tier = 'Low' THEN 1 ELSE 0 END) AS low_risk_skus
FROM warehouse.fact_inventory fi
JOIN warehouse.dim_store ds ON ds.store_sk = fi.store_sk
JOIN warehouse.dim_product dp ON dp.product_sk = fi.sku_id
GROUP BY
    ds.nl_region,
    ds.distribution_zone,
    dp.nl_category,
    dp.nl_department,
    fi.abc_class,
    fi.risk_tier;

-- View 4: Inventory Health
DROP VIEW warehouse.vw_inventory_health;
CREATE OR REPLACE VIEW warehouse.vw_inventory_health AS
SELECT
    ds.nl_region,
    ds.distribution_zone,
    dp.nl_category,
    dp.nl_department,
    fi.abc_class,
    fi.risk_tier,
    COUNT(*) AS total_skus,
    ROUND(AVG(fi.avg_daily_demand), 2) AS avg_daily_demand,
    ROUND(AVG(fi.safety_stock), 2) AS avg_safety_stock,
    ROUND(AVG(fi.reorder_point), 2) AS avg_reorder_point,
    ROUND(AVG(fi.stockout_risk_score), 2) AS avg_risk_score,
    SUM(CASE WHEN fi.risk_tier = 'HIGH' THEN 1 ELSE 0 END) AS high_risk_skus,
    SUM(CASE WHEN fi.risk_tier = 'MEDIUM' THEN 1 ELSE 0 END) AS medium_risk_skus,
    SUM(CASE WHEN fi.risk_tier = 'LOW' THEN 1 ELSE 0 END) AS low_risk_skus
FROM warehouse.fact_inventory fi
JOIN warehouse.dim_store ds ON ds.store_sk = fi.store_sk
JOIN warehouse.dim_product dp ON dp.product_sk = fi.sku_id
GROUP BY
    ds.nl_region,
    ds.distribution_zone,
    dp.nl_category,
    dp.nl_department,
    fi.abc_class,
    fi.risk_tier;


SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'vw_executive_summary'
ORDER BY ordinal_position;

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'vw_stockout_risk'
ORDER BY ordinal_position;

-- vw forecast vs Actual
CREATE OR REPLACE VIEW warehouse.vw_forecast_vs_actual AS
SELECT
    f.store_id,
    f.item_id,
    f.forecast_date,
    f.actual_units,
    f.predicted_units,
    f.model,
    ROUND(ABS(f.actual_units - f.predicted_units), 2)          AS abs_error,
    ROUND(
        ABS(f.actual_units - f.predicted_units) 
        / NULLIF(f.actual_units, 0) * 100, 1
    )                                                           AS pct_error,
    d.day_name,
    d.week_of_year,
    d.month_number,
    d.month_name,
    d.year,
    d.is_nl_holiday
FROM warehouse.fact_forecast f
JOIN warehouse.dim_date d 
    ON d.full_date = f.forecast_date;
