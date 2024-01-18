

  create or replace view `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_all_campaigns`
  OPTIONS(
      description="""Enth\u00e4lt alle Kampagnen aus GA4 und GA3."""
    )
  as 

WITH _historic_ua_campaigns AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`staging`.`stg_google_analytics_historic_campaigns`
),

ga4_campaigns AS(
    SELECT 
        MAX(Campaign) as Campaign,
        MAX(Partner) as Partner,
        MAX(Source) as Source,
        MAX(Medium) as Medium,
        CampaignID
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_all_events`
    GROUP BY 5
),

_final AS(
    SELECT * FROM _historic_ua_campaigns
    UNION DISTINCT
    SELECT * FROM ga4_campaigns
)

SELECT * FROM _final;

