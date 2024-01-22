

  create or replace view `oss-big-query-dashboard-prod`.`intermediate`.`int_google_ads_unique_campaigns`
  OPTIONS(
      description="""Enth\u00e4lt eine \u00dcbersicht aller Kampagnen ohne historische Informationen. Dient als einfache Datenbank der wichtigsten Metainfos der Kampagnen. Jede Kampagne hat genau einen Eintrag."""
    )
  as 

WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`staging`.`stg_google_ads_campaign_history`
),

_give_rownumbers AS(
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY id ORDER BY updated_at DESC) as rn
    FROM _raw
),

_distinct_campaigns AS(
    SELECT
        id ,
        campaign,
        Source,
        Medium,
        Partner,
        CampaignID
    FROM _give_rownumbers
    WHERE
        rn = 1
),

_final AS(
    SELECT * 
    FROM _distinct_campaigns
)

SELECT * FROM _final;

