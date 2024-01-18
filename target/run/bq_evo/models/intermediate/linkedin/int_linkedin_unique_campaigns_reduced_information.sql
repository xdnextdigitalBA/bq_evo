

  create or replace view `oss-big-query-dashboard-prod`.`intermediate`.`int_linkedin_unique_campaigns_reduced_information`
  OPTIONS(
      description="""Enth\u00e4lt eine \u00dcbersicht aller Kampagnen ohne historische Informationen. Dient als einfache Datenbank der wichtigsten Metainfos der Kampagnen. Jede Kampagne hat genau einen Eintrag."""
    )
  as 

WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`staging`.`stg_linkedin_campaign_history`
),

_selected_columns AS (
    SELECT
        id as campaign_id,
        Campaign, 
        "EVO" as Partner, 
        "cpc" as Medium, 
        "linkedin" as Source, 
        LOWER(CONCAT(Campaign, "linkedin", "cpc", "EVO")) AS CampaignID 
    
    FROM _raw
),

_final AS(
    SELECT 
        DISTINCT *
    FROM _selected_columns
)

SELECT * FROM _final;

