
  
    

    create or replace table `oss-big-query-dashboard-prod`.`mart`.`mrt_google_analytics_NDG_merged_ua_ga4_conversions_summarized`
      
    
    

    OPTIONS(
      description="""Enth\u00e4lt alle Conversiondaten bis einschl. 04.06.2023 aus Unisversal Analytics, alle Conversions ab 05.06.2023 aus Google Analytics 4.\nDas Zielvorhaben 'contact_form_button' ist hier nur f\u00fcr die Landingpage evo-ag.de/pv-aktion gefiltert.\n"""
    )
    as (
      

WITH ga4_conversions AS(
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
    );
  