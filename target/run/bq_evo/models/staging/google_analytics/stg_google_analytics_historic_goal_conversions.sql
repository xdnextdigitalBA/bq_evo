

  create or replace view `oss-big-query-dashboard-prod`.`staging`.`stg_google_analytics_historic_goal_conversions`
  OPTIONS(
      description="""Enth\u00e4lt alle historischen Zielvorhaben-Abschl\u00fcsse aus Universal Analytics / GA3"""
    )
  as 

WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`manual_data_upload`.`universal_analytics_historic_goal_conversions`
),

_final AS(
    SELECT *
    FROM _raw
)

SELECT * FROM _final;

