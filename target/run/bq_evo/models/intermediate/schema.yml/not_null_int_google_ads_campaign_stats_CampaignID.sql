select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select CampaignID
from `oss-big-query-dashboard-prod`.`intermediate`.`int_google_ads_campaign_stats`
where CampaignID is null



      
    ) dbt_internal_test