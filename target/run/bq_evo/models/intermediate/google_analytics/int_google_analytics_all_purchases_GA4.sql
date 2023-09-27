

  create or replace view `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_all_purchases_GA4`
  OPTIONS(
      description="""Enth\u00e4lt alle <purchase-events> aus Google Analytics 4. Inkl. aller zugeh\u00f6rigen Metainformationen aus GA4."""
    )
  as WITH _raw AS(
  SELECT *
  FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_all_events`
),

_select_purchase_events AS(
  SELECT * FROM _raw
  WHERE event_name = "purchase"
),

_final AS(
    SELECT *
    FROM _select_purchase_events
)

SELECT * FROM _final;

