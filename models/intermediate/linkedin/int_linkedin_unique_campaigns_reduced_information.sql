{{ config(
    tags=["daily"]
) }}

WITH _raw AS(
    SELECT *
    FROM {{ ref('stg_linkedin_campaign_history')}}
),

_selected_columns AS (
    SELECT
        id as campaign_id,
        Campaign, 
        "EVO" as Partner, 
        "cpc" as Medium, 
        "linkedin" as Source, 
        LOWER(CONCAT(Campaign, "linkedin", "cpc", "EVO")) AS CampaignID 
    
    FROM _raw
),

_final AS(
    SELECT 
        DISTINCT *
    FROM _selected_columns
)

SELECT * FROM _final