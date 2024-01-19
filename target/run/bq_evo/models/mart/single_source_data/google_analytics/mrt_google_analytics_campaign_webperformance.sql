
  
    

    create or replace table `oss-big-query-dashboard-prod`.`mart`.`mrt_google_analytics_campaign_webperformance`
      
    
    

    OPTIONS(
      description="""Enth\u00e4lt grundlegende Web-Performancewerte aller \u00fcber GA4 erfassten Kampagnen."""
    )
    as (
      

WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_all_events`

    
),

sessions_by_campaign AS(
  SELECT
    event_date as Date,
    CampaignID,

    COUNT(DISTINCT(CONCAT(user_pseudo_id,session_id))) as Sessions,
    COUNT(DISTINCT 
      CASE 
        WHEN session_engaged = '1' THEN CONCAT(user_pseudo_id,session_id) 
      END) as Sessions_Engaged,
    MAX(Medium) as Medium,
    MAX(Source) as Source,
    MAX(Partner) as Partner,

  FROM _raw
  GROUP BY 1,2
),

_add_engagement_rate AS(
    SELECT 
        Date,
        CampaignID,
        Sessions,
        Sessions_Engaged,
        (CASE
            WHEN Sessions > 0 THEN (Sessions_Engaged / Sessions) 
            ELSE 0
        END) as Engagement_Rate,
        Medium,
        Source,
        Partner
    FROM sessions_by_campaign
),

_added_columns AS(
    SELECT
        *,
        '(not set)' as Keyword,
        '(not set)' as KeywordMatchType
    FROM _add_engagement_rate
),

_final AS(
    SELECT *
    FROM _added_columns
)

SELECT * FROM _final
    );
  