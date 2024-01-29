

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

_linkedin_campaigns AS(
    SELECT
        Campaign,
        Medium,
        Partner,
        Source,
        'true' as IsPaid,
        CampaignID
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_linkedin_unique_campaigns_reduced_information`
),

_meta_campaigns AS(
    SELECT
        Campaign,
        Medium,
        Partner,
        Source,
        'true' as IsPaid,
        CampaignID
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_meta_unique_campaigns`    
),

_merge AS(
    SELECT * FROM _googleads_campaigns
    UNION ALL
    SELECT * FROM _google_analytics_campaigns
    UNION ALL
    SELECT * FROM _bingads_campaigns
    UNION ALL
    SELECT * FROM _linkedin_campaigns 
    UNION ALL
    SELECT * FROM _meta_campaigns  
),

_final AS(
    SELECT 
        DISTINCT *
    FROM _merge
)

SELECT * FROM _final