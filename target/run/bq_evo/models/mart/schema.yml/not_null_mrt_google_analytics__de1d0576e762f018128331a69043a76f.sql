select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select CampaignID
from `oss-big-query-dashboard-prod`.`mart`.`mrt_google_analytics_campaign_webperformance`
where CampaignID is null



      
    ) dbt_internal_test