{{ config(
    tags=["daily"]
) }}

WITH _raw AS(
    SELECT *
    FROM {{ source('bingads', 'campaign_history') }}
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

SELECT * FROM _final