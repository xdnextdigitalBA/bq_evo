

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
),

_add_Kampagnenprodukt AS(
  SELECT 
    *,
    COALESCE(
      CASE WHEN
          l_campaign LIKE '%:sg%' OR
          l_campaign LIKE '%:hs:%' OR
          l_campaign LIKE '%:str:%' OR
          l_campaign LIKE '%:ga:%' OR
          l_campaign LIKE '%prävention%' OR
          l_campaign LIKE '%smart display%' OR
          l_campaign LIKE '%brnd_os%' THEN "Strom/Gas Privat" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%wärme%' OR
          l_campaign LIKE '%waerme%' OR
          l_campaign LIKE '%:wä:%' THEN "Wärme" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%solar%' OR
          l_campaign LIKE '%photovoltaik%' OR
          l_campaign LIKE '%pv%' THEN "Solar" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%:sm:%' OR
          l_campaign LIKE '%smart%' THEN "Smart Meter" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%recruiting%' OR
          l_campaign LIKE '%recruting%' OR
          l_campaign LIKE '%personalmanagement%' OR
          (l_campaign LIKE '%rec%' AND NOT l_campaign = '(direct)' AND NOT l_campaign LIKE '%rechner%') OR
          l_campaign LIKE '%ausbildung%' OR
          l_campaign LIKE '%azubi%' OR
          l_campaign LIKE '%google_jobs_apply%' OR
          l_campaign LIKE '%gruppenleiter%' OR
          l_campaign LIKE '%abteilungsleiter%' OR
          l_campaign LIKE '%asset_mgr%' OR
          l_campaign LIKE '%manager%' OR
          l_campaign LIKE '%:rec%' THEN "Recruiting" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%verein%' OR
          l_campaign LIKE '%gewinnspiel%' OR
          l_campaign LIKE '%bierspende%' OR
          l_campaign LIKE '%sponsoring%' OR
          l_campaign LIKE '%wm-2018%' OR
          l_campaign LIKE '%image%' THEN "Image" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%service%' OR 
          l_campaign LIKE '%mehrwert%' THEN "Service" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%umzug%' THEN "Umzug" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%netzanschluss%' OR
          l_campaign LIKE '%hausanschluss%' THEN "Hausanschluss" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%e-mob%' OR
          l_campaign LIKE '%emobili%' THEN "E-Mobility" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%:gk:%' OR
          l_campaign LIKE '%gewerbe%' THEN "Strom/Gas Gewerbe" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%sommeraktion%' OR
          l_campaign LIKE '%:st%' OR
          l_campaign LIKE '%_st_%' OR
          l_campaign LIKE '%baumesse%' OR
          l_campaign LIKE '%z:%' THEN "Sonderthemen" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%app%' THEN "App" ELSE NULL END,
      CASE WHEN
          l_campaign LIKE '%(not set)%' OR
          l_campaign LIKE '%:intern:%' OR
          l_campaign LIKE '%_intern%' OR
          l_campaign LIKE '%test_kampagne%' OR
          l_campaign LIKE '%(organic)%' OR
          l_campaign LIKE '%(referral)%' OR
          l_campaign LIKE '%_campaignname%' OR
          l_campaign LIKE '%(direct)%' THEN "Sonstige" ELSE NULL END,
      CASE WHEN
          medium = 'cpc' THEN "Strom/Gas Privat" ELSE "Sonstige" END
    ) AS Kampagnenprodukt
  FROM _add_Kampagnenkategorie
),

_add_Kampagnenbetreuer AS(
  SELECT *,
      (CASE WHEN
          Medium IN ('cpc', 'ppc','cpa', 'cpm', 'cpv', 'cpp') AND
          (l_campaign NOT LIKE '%:intern:%' OR
          l_campaign NOT LIKE '%ia_nc_photovoltaik_solarbonus22' OR
          l_campaign NOT LIKE '%_intern%' OR
          l_campaign NOT LIKE '%(not set)%' OR
          l_campaign NOT LIKE '%nextdigital%' OR
          l_campaign NOT LIKE '%(organic)%') THEN "NDG" ELSE "EVO" END
      ) AS Kampagnenbetreuer
  FROM _add_Kampagnenprodukt
),

_add_Produktkategorie AS(
  SELECT *,
    COALESCE(
      CASE WHEN
          Kampagnenprodukt IN ("Strom/Gas Privat", "Strom/Gas Gewerbe") THEN
            COALESCE(
                CASE WHEN
                  l_campaign LIKE '%gas%' THEN "Gas" ELSE NULL END,
                CASE WHEN
                  l_campaign LIKE '%strom%' OR
                  l_campaign LIKE '%:str%' THEN "Strom" ELSE NULL END,
                CASE WHEN
                  l_campaign LIKE '%hs%' THEN "Heizstrom" ELSE "Mischkampagne/Sonstige" END
            ) ELSE NULL END, 
      CASE
        WHEN
          Kampagnenprodukt = "Recruiting" THEN
              CASE WHEN
                  l_campaign LIKE '%azubi%' OR
                  l_campaign LIKE '%ausbildung%' THEN "Ausbildung" ELSE "Sonstige" END
          ELSE Kampagnenprodukt END
    ) AS Produktkategorie
  FROM _add_Kampagnenbetreuer         
),

_add_stellenprofil AS(
  SELECT *,
    CASE WHEN Kampagnenprodukt = "Recruiting" THEN
      COALESCE(
        CASE WHEN
            l_campaign LIKE '%kampagnenmanager%' THEN "Kampagnenmanager/in" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%mechatroniker%' THEN "Mechatroniker/in" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%energieffizienzmanager%' OR
            l_campaign LIKE '%effizienzmanager%' THEN "Energieffizienzmanager/in" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%ref digitale kampagnen%' OR 
            l_campaign LIKE '%referentdigitalekampagnen' THEN "Referent/in digitale Kampagnen" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%manager digitale vermarktung%' THEN "Manager/in digitale Vermarktung" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%gruppenleiter netzanschluss%' OR
            l_campaign LIKE '%gruppenleiter_netzan' THEN "Gruppenleiter/in Netzanschluss" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%leiter geschäftsentwicklung%' THEN "Leiter/in Geschäftsentwicklung" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%ref veranstaltungsmanagement%' THEN "Referent/in Veranstaltungsmanagement" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%projektingenieur produktion & handel%' OR
            l_campaign LIKE '%asset_mgr_prod_ha' THEN "Projektingenieur/in Produktion & Handel" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%referent prozesse & dienstleistersteuerung%' OR
            l_campaign LIKE '%referentprozesse&dienstleistungen%' OR
            l_campaign LIKE '%referentprozesse%' THEN "Referent/in Prozesse & Dienstleistersteuerung" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%prozessmanagervertrieb%' THEN "Prozessmanager/in Vertrieb" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%manager digitale vermarktung%' THEN "Manager/in digitale Vermarktung" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%projektmanagerdigitalisierungvertriebsprozesse%' THEN "Projektmanager/in Digitalisierung Vertriebsprozesse" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%onlinemarketingmanager%' OR
            l_campaign LIKE '%online marketing manager%' THEN "Online Marketing Manager/in" ELSE NULL END,
        CASE WHEN
            l_campaign LIKE '%abteilungsleiter gfe_pe%' OR
            l_campaign LIKE '%abteilungsleiter_gfe_pe%' THEN "Abteilungsleiter/in GFE/PE" ELSE "Sonstige" END
      ) END AS Stellen_ID
    
  FROM _add_Produktkategorie
),

_add_gebiet AS(
  SELECT 
    *,
    COALESCE(
        CASE WHEN l_campaign LIKE '%:%' THEN SPLIT(Campaign, ':')[OFFSET(0)] ELSE NULL END,
        CASE WHEN l_campaign LIKE '%[%]3A%' THEN SPLIT(Campaign, '%3A')[OFFSET(0)] ELSE 'undefined' END
    ) AS Gebiet
  FROM _add_stellenprofil
),

_add_gebiet_cluster AS(
  SELECT 
    *,
    COALESCE(
      CASE WHEN Gebiet IN ('A', 'OF30', 'OF', 'AKR', 'ZZZ_A', 'A[x]', 'ZZZ_A[x]') THEN "Stammgebiet" ELSE NULL END,
      CASE WHEN Gebiet IN ('D', 'FFM', 'HAN', 'NRW', 'DA', 'OOA', 'MW', 'KOB', 'WIN', 'HOLI', 'LIM', 'FG', 'C', 'H', 'E', 'ZZZ_C', 'ZZZ_D', 'HD', 'ZZ', 'Z', 'ASB') THEN "OOA" ELSE "undefined" END
    ) AS Gebiet_clustered
  FROM _add_gebiet
),

_add_Werbenetzwerk AS(
  SELECT
    *,
    COALESCE(
      CASE WHEN Source = "google" THEN
        COALESCE(
          CASE WHEN 
              l_campaign LIKE '%:d:%' OR
              l_campaign LIKE '%DP_%' THEN "Google Display" ELSE NULL END,
          CASE WHEN
              l_campaign LIKE '%:yt:%' THEN "YouTube" ELSE NULL END,
          CASE WHEN
              l_campaign LIKE '%app%' THEN "Google App" ELSE NULL END,
          CASE WHEN 
              l_campaign LIKE '%:s:%' OR
              l_campaign LIKE '%SEA_%' THEN "Google Suchnetzwerk" ELSE "Google Suchnetzwerk" END
        ) ELSE NULL END,
      CASE WHEN Source = "facebook" THEN "Facebook" ELSE NULL END,
      CASE WHEN Source = "instagram" THEN "Instagram" ELSE NULL END,
      CASE WHEN Source = "bing" THEN "Bing" ELSE NULL END,
      CASE WHEN Source LIKE '%linkedin%' THEN "LinkedIn" ELSE "Sonstige" END   
      ) AS Werbenetzwerk
    FROM _add_gebiet_cluster
    )

SELECT * EXCEPT(l_campaign) FROM _add_Werbenetzwerk