select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select ZielvorhabenID
from `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_NDG_conversionevents_GA4`
where ZielvorhabenID is null



      
    ) dbt_internal_test