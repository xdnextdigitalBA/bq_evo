-- back compat for old kwarg name
  
  
        
            
                
                
            
                
                
            
        
    

    

    merge into `oss-big-query-dashboard-prod`.`mart`.`mrt_bing_ads_basic_campaign_stats` as DBT_INTERNAL_DEST
        using (
        select
        * from `oss-big-query-dashboard-prod`.`mart`.`mrt_bing_ads_basic_campaign_stats__dbt_tmp`
        ) as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.Date = DBT_INTERNAL_DEST.Date
                ) and (
                    DBT_INTERNAL_SOURCE.Campaign = DBT_INTERNAL_DEST.Campaign
                )

    
    when matched then update set
        `Date` = DBT_INTERNAL_SOURCE.`Date`,`Campaign` = DBT_INTERNAL_SOURCE.`Campaign`,`CampaignID` = DBT_INTERNAL_SOURCE.`CampaignID`,`Source` = DBT_INTERNAL_SOURCE.`Source`,`Medium` = DBT_INTERNAL_SOURCE.`Medium`,`Partner` = DBT_INTERNAL_SOURCE.`Partner`,`Keyword` = DBT_INTERNAL_SOURCE.`Keyword`,`KeywordMatchType` = DBT_INTERNAL_SOURCE.`KeywordMatchType`,`Impressions` = DBT_INTERNAL_SOURCE.`Impressions`,`Clicks` = DBT_INTERNAL_SOURCE.`Clicks`,`Cost` = DBT_INTERNAL_SOURCE.`Cost`
    

    when not matched then insert
        (`Date`, `Campaign`, `CampaignID`, `Source`, `Medium`, `Partner`, `Keyword`, `KeywordMatchType`, `Impressions`, `Clicks`, `Cost`)
    values
        (`Date`, `Campaign`, `CampaignID`, `Source`, `Medium`, `Partner`, `Keyword`, `KeywordMatchType`, `Impressions`, `Clicks`, `Cost`)


    