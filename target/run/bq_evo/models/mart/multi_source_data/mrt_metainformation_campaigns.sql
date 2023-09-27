
  
    

    create or replace table `oss-big-query-dashboard-prod`.`mart`.`mrt_metainformation_campaigns`
      
    
    

    OPTIONS(
      description="""Enth\u00e4lt Kampagnen aus allen Quelldatensystemen mit Metainformationen."""
    )
    as (
      

WITH _googleads_campaigns AS(
    SELECT
        campaign as Campaign,
        Medium,
        Partner,
        Source,
        'true' as IsPaid,
        CampaignID
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_google_ads_unique_campaigns`
),

_google_analytics_campaigns AS(
    SELECT
        Campaign,
        Medium,
        Partner,
        Source,
        CASE
            WHEN Medium IN ('cpc', 'ppc','cpa', 'cpm', 'cpv', 'cpp') THEN 'true' 
            ELSE 'false'
        END as IsPaid,
        CampaignID
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_all_campaigns`
),

_bingads_campaigns AS(
    SELECT
        Campaign,
        Medium,
        Partner,
        Source,
        'true' as IsPaid,
        CampaignID
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_bing_ads_unique_campaigns`
),

_merged_googleads_and_analytics AS(
    SELECT * FROM _googleads_campaigns
    UNION ALL
    SELECT * FROM _google_analytics_campaigns
),

_merged_bingads AS(
    SELECT * FROM _merged_googleads_and_analytics
    UNION ALL
    SELECT * FROM _bingads_campaigns    
),

_final AS(
    SELECT 
        DISTINCT *
    FROM _merged_bingads
)

SELECT * FROM _final
    );
  