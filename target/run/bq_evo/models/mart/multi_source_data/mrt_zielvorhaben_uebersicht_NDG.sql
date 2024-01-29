
  
    

    create or replace table `oss-big-query-dashboard-prod`.`mart`.`mrt_zielvorhaben_uebersicht_NDG`
      
    
    

    OPTIONS(
      description="""Enth\u00e4lt eine \u00dcbersicht aller verwendeten Conversionaktionen von NDG."""
    )
    as (
      

WITH _raw AS(
  SELECT DISTINCT
    ZielvorhabenName, 
    Partner,
    ZielvorhabenID
  FROM `oss-big-query-dashboard-prod`.`mart`.`mrt_google_analytics_NDG_merged_ua_ga4_conversions_summarized`
),

_add_Kategorie AS(
  SELECT
    *,
    COALESCE(
      CASE WHEN ZielvorhabenName 
        IN (
            'EVO Solar Pachten / EVO Solar', 
            'Kontaktaufnahme: Kontaktformular (insb. Solar)',
            'conversion_solarrechner',
            'evo_solar_pva_check_sent_available',
            'lead_form_evo_solar_lp',
            'lead_form_evo_solar_pv_aktion'
        ) THEN "Lead - Solar" ELSE NULL END,
      CASE WHEN ZielvorhabenName 
        IN (
            'EVO Wärme 360 - Heizungsangebot anfordern',
            'evo_heatpump_check_sent_available',
            'lead_form_heatpump_lp'
        ) THEN "Lead - Wärme" ELSE NULL END,  
      CASE WHEN ZielvorhabenName 
        IN(
            'OSS Registrierung - DOI Hinweis (ehem. Solarrechner - Kontakt - Senden)',
            'oss_registration_doi'
        ) THEN "Registrierung - Online Service" ELSE NULL END,
      CASE WHEN ZielvorhabenName 
        IN('Onlinebewerbung (ehem.)Vertragsabschluss Mobile') THEN "Lead - Recruiting" ELSE NULL END,
      CASE WHEN ZielvorhabenName 
        IN('Tarifrechnernutzung (ehem. Vertragsabschluss)') THEN "Lead - Tarifberechnung" ELSE NULL END,
      CASE WHEN ZielvorhabenName 
        IN(
            'PV Rechner Anfrage gesendet',
            'click_online_application',
            'purchase'
        ) THEN "Sonstige/nicht mehr zählen" ELSE "Sonstige/nicht mehr zählen" END
    ) as KategorieZielvorhaben
  FROM _raw
)

SELECT * FROM _add_Kategorie
    );
  