

  create or replace view `oss-big-query-dashboard-prod`.`staging`.`stg_google_analytics_historic_transactions`
  OPTIONS(
      description=""""""
    )
  as 

WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`manual_data_upload`.`universal_analytics_historic_transactions`
),

_final AS(
    SELECT *
    FROM _raw
)

SELECT * FROM _final;

