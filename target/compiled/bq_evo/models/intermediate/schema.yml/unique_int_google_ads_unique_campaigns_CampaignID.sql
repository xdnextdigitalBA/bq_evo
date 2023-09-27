
    
    

with dbt_test__target as (

  select CampaignID as unique_field
  from `oss-big-query-dashboard-prod`.`intermediate`.`int_google_ads_unique_campaigns`
  where CampaignID is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


