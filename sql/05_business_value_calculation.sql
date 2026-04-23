SELECT fi.sku_id, dp.item_id, sp.sell_price
FROM warehouse.fact_inventory fi
LEFT JOIN warehouse.dim_product dp ON fi.sku_id = dp.product_sk
LEFT JOIN staging.stg_prices sp ON dp.item_id = sp.item_id
LIMIT 5;


WITH safety_stock_comparison AS (
    SELECT
        fi.sku_id,
        fi.store_sk,
        fi.avg_daily_demand,
        fi.safety_stock                              AS optimised_safety_stock,
        fi.avg_daily_demand * 14                     AS manual_safety_stock,
        GREATEST(
            (fi.avg_daily_demand * 14) - fi.safety_stock, 0
        )                                            AS excess_units,
        AVG(sp.sell_price::numeric)                  AS avg_unit_price
    FROM warehouse.fact_inventory fi
    LEFT JOIN warehouse.dim_product dp ON fi.sku_id = dp.product_sk
    LEFT JOIN staging.stg_prices sp ON dp.item_id = sp.item_id
    GROUP BY
        fi.sku_id, fi.store_sk,
        fi.avg_daily_demand, fi.safety_stock
),
cost_calculation AS (
    SELECT
        sku_id,
        store_sk,
        excess_units,
        avg_unit_price,
        excess_units * avg_unit_price                AS excess_inventory_value,
        excess_units * avg_unit_price * 0.25         AS annual_holding_cost_saved
    FROM safety_stock_comparison
    WHERE avg_unit_price IS NOT NULL
)
SELECT
    ROUND(SUM(excess_inventory_value)::numeric, 2)   AS total_excess_value_eur,
    ROUND(SUM(annual_holding_cost_saved)::numeric, 2) AS total_annual_saving_eur,
    COUNT(*)                                          AS sku_store_combinations
FROM cost_calculation;