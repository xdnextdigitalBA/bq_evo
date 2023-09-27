-- back compat for old kwarg name
  
  
        
    

    

    merge into `oss-big-query-dashboard-prod`.`mart`.`mrt_google_analytics_NDG_merged_ua_ga4_conversions_summarized` as DBT_INTERNAL_DEST
        using (WITH ga4_conversions AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_NDG_conversionevents_GA4`
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
    FROM `oss-big-query-dashboard-prod`.`staging`.`stg_google_analytics_historic_goal_conversions`
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
        ) as DBT_INTERNAL_SOURCE
        on (FALSE)

    

    when not matched then insert
        (`Date`, `ZielvorhabenName`, `ZielvorhabenID`, `CampaignID`, `Source`, `Medium`, `Partner`, `Keyword`, `KeywordMatchType`, `Conversions`)
    values
        (`Date`, `ZielvorhabenName`, `ZielvorhabenID`, `CampaignID`, `Source`, `Medium`, `Partner`, `Keyword`, `KeywordMatchType`, `Conversions`)


    