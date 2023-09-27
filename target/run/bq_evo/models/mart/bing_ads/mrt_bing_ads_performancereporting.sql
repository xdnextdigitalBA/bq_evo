
  
    

    create or replace table `oss-big-query-dashboard-prod`.`mart`.`mrt_bing_ads_performancereporting`
      
    
    

    OPTIONS(
      description="""Enth\u00e4lt alle Vermarktungsstatistiken f\u00fcr das Performancereporting. Keine Conversioninformationen enthalten, somit keine Bewertung der Kampagnen m\u00f6glich. Lediglich deskriptive Informationen. Muss in Performancereporting mit Conversioninformationen verkn\u00fcpft werden."""
    )
    as (
      

WITH _raw AS(
  SELECT *
  FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_bing_ads_campaign_performance_joined_campaign_names`

      
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
    );
  