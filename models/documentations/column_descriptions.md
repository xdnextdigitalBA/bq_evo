{% docs campaignID %}
Wichtigster Schlüssel für NDG - setzt sich aus Medium, Source, Partner & Kampagnenname zusammen. Darf niemals leeren Wert enthalten.

Primärschlüssel in folgenden Tabelle:
- mrt_metainformation_campaigns
- stg_google_analytics_352128287
- int_google_ads_unique_campaigns
- int_bing_ads_unique_campaigns
- int_google_analytics_all_campaigns
{% enddocs %}

{% docs Partner %}
Ist immer EVO, darf keine leeren Werte enthalten. Kann zukünftig zur Differenzierung mehrerer Marken genutzt werden.
{% enddocs %}

{% docs ad_account %}
ID des Werbekontos
{% enddocs %}

{% docs cost %}
Kosten in Euro
{% enddocs %}

{% docs clicks %}
Anzeigenklicks
{% enddocs %}

{% docs impressions %}
Anzeigenimpressionen
{% enddocs %}

{% docs fivetran %}
Automatisch durch Fivetran generierte Spalte. Kann zu Logging-Zwecken genutzt werden.
{% enddocs %}

{% docs unused_columns %}
Spaltenbedeutung bitte in API-Dokumentation nachprüfen.
{% enddocs %}

{% docs device %}
Gerät über das das Event generiert wurde (bspw. Anzeigenklick oder Sitzungsbeginn)
{% enddocs %}

{% docs campaign_name %}
Kampagnenname wie in der jeweiligen Nutzeroberfläche angezeigt.
{% enddocs %}

{% docs source_medium_manual %}
Manuell durch NDG gesetzt Quelle/Medium.
{% enddocs %}

{% docs keyword %}
Aufgrund enormer Speicherauswirkungen wird die Spalte aus den Datenquellen nicht bezogen. Enthält daher zum Status-Quo keine Informationen (19.09.2023).
{% enddocs %}

{% docs KeywordMatchType %}
Aufgrund enormer Speicherauswirkungen wird die Spalte aus den Datenquellen nicht bezogen. Enthält daher zum Status-Quo keine Informationen (19.09.2023).
{% enddocs %}