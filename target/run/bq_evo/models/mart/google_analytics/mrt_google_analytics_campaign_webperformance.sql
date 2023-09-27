-- back compat for old kwarg name
  
  
        
            
                
                
            
                
                
            
        
    

    

    merge into `oss-big-query-dashboard-prod`.`mart`.`mrt_google_analytics_campaign_webperformance` as DBT_INTERNAL_DEST
        using (
        select
        * from `oss-big-query-dashboard-prod`.`mart`.`mrt_google_analytics_campaign_webperformance__dbt_tmp`
        ) as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.Date = DBT_INTERNAL_DEST.Date
                ) and (
                    DBT_INTERNAL_SOURCE.CampaignID = DBT_INTERNAL_DEST.CampaignID
                )

    
    when matched then update set
        `Date` = DBT_INTERNAL_SOURCE.`Date`,`CampaignID` = DBT_INTERNAL_SOURCE.`CampaignID`,`Sessions` = DBT_INTERNAL_SOURCE.`Sessions`,`Sessions_Engaged` = DBT_INTERNAL_SOURCE.`Sessions_Engaged`,`Engagement_Rate` = DBT_INTERNAL_SOURCE.`Engagement_Rate`,`Medium` = DBT_INTERNAL_SOURCE.`Medium`,`Source` = DBT_INTERNAL_SOURCE.`Source`,`Partner` = DBT_INTERNAL_SOURCE.`Partner`,`Keyword` = DBT_INTERNAL_SOURCE.`Keyword`,`KeywordMatchType` = DBT_INTERNAL_SOURCE.`KeywordMatchType`
    

    when not matched then insert
        (`Date`, `CampaignID`, `Sessions`, `Sessions_Engaged`, `Engagement_Rate`, `Medium`, `Source`, `Partner`, `Keyword`, `KeywordMatchType`)
    values
        (`Date`, `CampaignID`, `Sessions`, `Sessions_Engaged`, `Engagement_Rate`, `Medium`, `Source`, `Partner`, `Keyword`, `KeywordMatchType`)


    