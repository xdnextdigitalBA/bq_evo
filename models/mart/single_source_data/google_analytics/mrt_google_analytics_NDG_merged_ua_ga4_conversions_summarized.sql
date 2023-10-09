{{ config(
    tags=["performancereporting", "vermarktungsdashboard", "google analytics"]
) }}

WITH ga4_conversions AS(
    SELECT *
    FROM {{ ref('int_google_analytics_NDG_conversionevents_GA4')}}
    WHERE 
        Date > '2023-06-04'
),

ua_conversions AS(
    SELECT
        Date,
        NameZielvorhaben as ZielvorhabenName,
        LOWER(CONCAT(NameZielvorhaben, Partner)) as ZielvorhabenID,
        CampaignID,
        Source,
        Medium,
        Partner,
        Keyword,
        KeywordMatchType,
        Conversions
    FROM {{ ref('stg_google_analytics_historic_goal_conversions')}}
    WHERE Date <= '2023-06-04'
),

_merged_step1 AS(
    SELECT * FROM ga4_conversions
    UNION ALL
    SELECT * FROM ua_conversions
),

_final AS(
    SELECT *
    FROM _merged_step1
)

SELECT * FROM _final