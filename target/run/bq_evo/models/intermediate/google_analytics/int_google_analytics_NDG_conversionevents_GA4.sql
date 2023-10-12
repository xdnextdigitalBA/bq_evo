

  create or replace view `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_NDG_conversionevents_GA4`
  OPTIONS(
      description="""Enth\u00e4lt alle relevanten Conversionevents aus Google Analytics 4 f\u00fcr NDG-Vermarktung. Inklusive aller E-Commerce-Events (ohne Metainformationen).\nF\u00fcr das Conversion-Event 'contact_form_button' wird nur die Landingpage evo-ag.de/pv-aktion gefiltert.\n"""
    )
  as WITH _raw AS(
  SELECT *
  FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_google_analytics_all_events`
),

_conversions_NDG as(
  SELECT 
    event_date as Date,
    event_name as ZielvorhabenName, 
    CampaignID,
    Source,
    Medium,

    MAX(Partner) as Partner,

    count(event_date) as Conversions,

  FROM _raw
  WHERE (
    event_name = 'lead_form_evo_solar_lp' OR
    event_name = 'evo_solar_pva_check_sent_available' OR
    (event_name = 'contact_form_button' AND page_location LIKE '%pv-aktion%') OR
    event_name = 'click_online_application' OR
    event_name = 'oss_registration_doi' OR
    event_name = 'click_tarifrechnernutzung' OR
    event_name = 'conversion_solarrechner' OR
    event_name = 'purchase'
  )

  GROUP BY 1,2,3,4,5
),

_added_columns AS(
  SELECT 
      Date,
      ZielvorhabenName,
      LOWER(CONCAT(ZielvorhabenName, Partner)) as ZielvorhabenID,
      CampaignID,
      Source,
      Medium,
      Partner,
      '(not set)' as Keyword,
      '(not set)' as KeywordMatchType,
      Conversions
  FROM _conversions_NDG
),

_final AS(
  SELECT *
  FROM _added_columns
)

SELECT * FROM _final;

