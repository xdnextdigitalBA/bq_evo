{{
  config(
    unique_key=['Date', 'Campaign'],
    on_schema_change='sync_all_columns',
    tags=["performancereporting", "vermarktungsdashboard", "bing ads"]
    )
}}

WITH _raw AS(
  SELECT *
  FROM {{ ref('int_bing_ads_campaign_performance_joined_campaign_names')}}
 
    {% if is_incremental() %}

      WHERE
      --Update table for the past seven days + today
      Date >= current_date()-7
        
    {% endif %}
),

_selected_columns AS(
  SELECT 
    Date,
    Campaign,
    
    CampaignID,
    Source,
    Medium,
    Partner,
    '(not set)' as Keyword,
    '(not set)' as KeywordMatchType,
    
    Impressions,
    Clicks,
    Cost

  FROM _raw
),

_final_aggregation AS(
  SELECT 
    Date,
    Campaign,
    
    MAX(CampaignID) as CampaignID,
    MAX(Source) as Source,
    MAX(Medium) as Medium,
    MAX(Partner) as Partner,
    MAX(Keyword) as Keyword,
    MAX(KeywordMatchType) as KeywordMatchType,
    
    SUM(Impressions) as Impressions,
    SUM(Clicks) as Clicks,
    SUM(Cost) as Cost

  FROM _selected_columns
  GROUP BY 1,2
)

SELECT * FROM _final_aggregation