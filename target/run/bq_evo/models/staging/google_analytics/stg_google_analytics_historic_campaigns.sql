

  create or replace view `oss-big-query-dashboard-prod`.`staging`.`stg_google_analytics_historic_campaigns`
  OPTIONS(
      description="""Enth\u00e4lt alle historischen Kampagnen aus Universal Analytics / GA3"""
    )
  as WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`manual_data_upload`.`universal_analytics_historic_campaigns`
),

_final AS(
    SELECT *
    FROM _raw
)

SELECT * FROM _final;

