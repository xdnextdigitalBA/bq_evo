select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select id
from `oss-big-query-dashboard-prod`.`staging`.`stg_google_ads_campaign_stats`
where id is null



      
    ) dbt_internal_test