WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`manual_data_upload`.`universal_analytics_historic_transactions`
),

_final AS(
    SELECT *
    FROM _raw
)

SELECT * FROM _final