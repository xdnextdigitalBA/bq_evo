select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select CampaignID
from `oss-big-query-dashboard-prod`.`intermediate`.`int_bing_ads_unique_campaigns`
where CampaignID is null



      
    ) dbt_internal_test