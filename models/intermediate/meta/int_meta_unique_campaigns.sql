WITH _raw AS(
    SELECT *
    FROM {{ ref('stg_meta_campaign_information')}}
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

SELECT * FROM _final