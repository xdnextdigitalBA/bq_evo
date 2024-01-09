{{ config(
    tags=["daily"]
) }}

WITH _raw AS(
    SELECT *
    FROM {{ source('facebook_ads', 'fb_campaign_information') }}
),

_renamed_columns AS(
    SELECT 
        * EXCEPT (campaign_name),
        campaign_name as Campaign
    FROM _raw
),

_added_more_metadata AS(
    SELECT 
        *,
        'cpc' as Medium,
        'EVO' as Partner,
        CASE
            WHEN Campaign LIKE '%:IG%' AND Campaign NOT LIKE '%:FB:IG:%' THEN 'instagram'
            WHEN Campaign LIKE '%:FB:IG:%' OR Campaign LIKE '%:FB:%' THEN 'facebook'
            ELSE '(not set)'
        END AS Source,
        'true' as IsPaid
    FROM _renamed_columns
),

_added_campaignid AS(
    SELECT
        *,
        LOWER (CONCAT(Campaign, Source, Medium, Partner)) as CampaignID
    FROM _added_more_metadata
),

_final AS(
    SELECT *
    FROM _added_campaignid
)

SELECT * FROM _final