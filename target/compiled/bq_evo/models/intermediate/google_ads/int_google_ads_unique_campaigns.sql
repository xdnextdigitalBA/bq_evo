

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

SELECT * FROM _final