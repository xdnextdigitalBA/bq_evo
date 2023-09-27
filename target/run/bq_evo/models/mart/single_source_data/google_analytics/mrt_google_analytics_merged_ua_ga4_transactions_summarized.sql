-- back compat for old kwarg name
  
  
        
    

    

    merge into `oss-big-query-dashboard-prod`.`mart`.`mrt_google_analytics_merged_ua_ga4_transactions_summarized` as DBT_INTERNAL_DEST
        using (WITH _raw AS(
  SELECT 
    event_date as Date,
    Campaign,
    Medium,
    Source,
    item_category as ProductCategory,
    '(not set)' as Keyword,
    '(not set)' as KeywordMatchType,
    Partner,
    CampaignID
  FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_all_purchases_GA4`
  WHERE 
    transaction_id NOT LIKE 'TEST%'
),

_aggregation_on_day AS(
  SELECT
    Date,
    Campaign,
    Medium,
    Source,
    ProductCategory,
    count(Date) as Transactions,
    MAX(Keyword) as Keyword,
    MAX(KeywordMatchType) as KeywordMatchType,
    MAX(Partner) as Partner,
    CampaignID
  FROM _raw
  WHERE Date >= '2023-06-05'
  GROUP BY 1,2,3,4,5,10
),

evo_ecommerce_ua AS(
  SELECT *
  FROM `oss-big-query-dashboard-prod`.`staging`.`stg_google_analytics_historic_transactions`
  WHERE Date < '2023-06-05'
),

_merged_step1 AS(
  SELECT * FROM _aggregation_on_day
  UNION ALL
  SELECT * FROM evo_ecommerce_ua
),

_final AS(
  SELECT * FROM _merged_step1
)

SELECT * FROM _final
        ) as DBT_INTERNAL_SOURCE
        on (FALSE)

    

    when not matched then insert
        (`Date`, `Campaign`, `Medium`, `Source`, `ProductCategory`, `Transactions`, `Keyword`, `KeywordMatchType`, `Partner`, `CampaignID`)
    values
        (`Date`, `Campaign`, `Medium`, `Source`, `ProductCategory`, `Transactions`, `Keyword`, `KeywordMatchType`, `Partner`, `CampaignID`)


    