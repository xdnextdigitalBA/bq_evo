{{
  config(
    unique_key=['date', 'Campaign'],
    on_schema_change='sync_all_columns',
    tags=["performancereporting", "vermarktungsdashboard", "google ads"]
    )
}}

WITH _raw AS(
  SELECT *
  FROM {{ ref('int_google_ads_campaign_stats')}}

    {% if is_incremental() %}

      WHERE
      --Update table for the past seven days + today
      date >= current_date()-7
        
    {% endif %}
),

_selected_columns AS(
  SELECT 
    date as Date,
    Campaign,
    
    CampaignID,
    Source,
    Medium,
    Partner,
    '(not set)' as Keyword,
    '(not set)' as KeywordMatchType,
    
    impressions as Impressions,
    clicks as Clicks,
    cost as Cost

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