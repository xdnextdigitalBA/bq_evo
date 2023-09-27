select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select id
from `oss-big-query-dashboard-prod`.`intermediate`.`int_google_ads_unique_campaigns`
where id is null



      
    ) dbt_internal_test