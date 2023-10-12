

  create or replace view `oss-big-query-dashboard-prod`.`staging`.`stg_bing_ads_campaign_history`
  OPTIONS(
      description="""\u00c4nderungshistorie der Kampagnen. Jede Kampagne kann mehrfach auftauchen."""
    )
  as WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`bingads`.`campaign_history`
),


_added_columns AS (
    SELECT
        *,
        'cpc' as Medium,
        'bing' as Source,
        (CASE 
            WHEN account_id = 156001989 THEN 'EVO'
        END) as Partner,
    FROM _raw
),

_added_campaignid AS (
    SELECT 
        *,
        LOWER (CONCAT(name, Source, Medium, Partner)) as CampaignID
    FROM _added_columns
),

_final AS(
    SELECT *
    FROM _added_campaignid
)

SELECT * FROM _final;

