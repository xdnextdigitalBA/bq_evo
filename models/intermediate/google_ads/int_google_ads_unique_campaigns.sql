{{ config(
    tags=["daily"]
) }}

WITH _raw AS(
    SELECT *
    FROM {{ ref('stg_google_ads_campaign_history')}}
),

_distinct_campaigns AS(
    SELECT
        MAX(id) as id ,
        MAX(campaign) as campaign,
        MAX(Source) as Source,
        MAX(Medium) as Medium,
        MAX(Partner) as Partner,
        CampaignID
    FROM _raw
    GROUP BY 6
),

_final AS(
    SELECT * 
    FROM _distinct_campaigns
)

SELECT * FROM _final