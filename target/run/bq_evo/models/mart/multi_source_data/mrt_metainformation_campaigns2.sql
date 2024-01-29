
  
    

    create or replace table `oss-big-query-dashboard-prod`.`mart`.`mrt_metainformation_campaigns2`
      
    
    

    OPTIONS(
      description=""""""
    )
    as (
      

WITH _raw AS(
  SELECT 
    Campaign,
    Medium,
    Partner,
    Source,
    IsPaid,
    CampaignID,
    LOWER(Campaign) AS l_campaign 
  FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_all_campaigns`
),

_add_Kampagnenkategorie AS(
  SELECT
    *,
    (CASE
      WHEN 
        l_campaign LIKE '%brnd%' OR
        l_campaign LIKE '%brand%' THEN "Brand" ELSE "Generisch"
    END) AS Kampagnenkategorie
  FROM _raw
)

SELECT * FROM _add_Kampagnenkategorie
    );
  