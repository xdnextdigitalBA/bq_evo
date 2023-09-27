

  create or replace view `oss-big-query-dashboard-prod`.`intermediate`.`int_meta_unique_campaigns`
  OPTIONS(
      description="""Enth\u00e4lt alle Metakampagnen."""
    )
  as WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`staging`.`stg_meta_campaign_information`
),

_distinct_campaigns AS(
    SELECT
        MAX(Campaign) as Campaign,
        MAX(Source) as Source,
        MAX(Medium) as Medium,
        MAX(Partner) as Partner,
        CampaignID
    FROM _raw
    GROUP BY 5
),

_final AS(
    SELECT * 
    FROM _distinct_campaigns
)

SELECT * FROM _final;

