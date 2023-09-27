WITH _raw_performance AS(
    SELECT *
    FROM {{ ref('stg_linkedin_ad_analytics_by_campaign')}}
),

_raw_unique_campaigns AS(
    SELECT *
    FROM {{ ref('int_linkedin_unique_campaigns_reduced_information')}}
),

_joined AS(
    SELECT * FROM _raw_unique_campaigns
    INNER JOIN _raw_performance
    ON _raw_unique_campaigns.campaign_id = _raw_performance.campaign_id
),

_drop_campaign_id AS(
    SELECT * EXCEPT (campaign_id)
    FROM _joined
),

_final AS(
    SELECT 
        * EXCEPT(Date),
        CAST(Date AS DATE) as Date
    FROM _drop_campaign_id
)

SELECT * FROM _final