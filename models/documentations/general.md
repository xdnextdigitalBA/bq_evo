{% docs __overview__ %}
# Willkommen! 

Willkommen zur Dokumentation der Data-Pipeline der EVO.

# Ansprechpartner
**Benedict Altgassen:** benedict.altgassen@nextdigital.de

# Informationen zur Strukturierung der Modelle
**Staging:**

Alle Modelle im Staging-Ordner/-Dataset enthalten die Daten der Rohdatenquellen mit minimalen Anpassungen.
Hier werden lediglich Anpassungen an Spaltenbezeichnungen vorgenommen oder wie bei Google Analytics 4 vorbereitende Transformationen, um die Quelldaten in ein besser handhabbares Format zu bringen.
Die Unterordner sind nach den Quelldaten-Systemen strukturiert. Auch zukünftige Datenquellen wie bspw. das Admin-Tool erhalten einen separaten Unterordner erhalten.
**Die Modelle sind nicht für die Verwendung in Reportings, Dashboards oder Ad-Hoc-Analysen gedacht.**

**Intermediate:**

Alle Modelle im Intermediate-Ordner/-Dataset enthalten ggü. den Staging-Modellen weitreichende Verfeinerungen. Es werden Datenbereinigungen vorgenommen, Gruppierungen sowie Joins als vorbereitende Maßnahmen zur Weiterverarbeitung durchgeführt. Darüber hinaus werden zusätzlich notwendige Metriken auf Basis der Rohdaten berechnet.
Die Unterordner sind nach den Quelldaten-Systemen strukturiert. Auch zukünftige Datenquellen wie bspw. das Admin-Tool erhalten einen separaten Unterordner erhalten.
**Die Modelle sind nicht für die Verwendung in Reportings, Dashboards oder Ad-Hoc-Analysen gedacht.**

**Mart:**
Alle Modelle im Mart-Ordner/-Dataset bauen auf Modellen der Intermediate-Stufe auf. Es sollen im Wesentlichen Joins von verschiedenen Intermediate-Tabellen vorgenommen werden. Neue Metriken sollen nur berechnet werden, wenn es zuvor aufgrund der fehlenden Joins nicht möglich war.
**Jedes Modell enthält eine vollständig vorbereitete Tabelle, die explizit als Input für einen konkreten Anwendungsfall dienen.**

# Verwendung von Tags

Tags werden primär auf der Ebene der "Mart-Modelle" verwendet. Sie dienen der schnellen Filterung von Modellen für einen bestimmten Zweck. Jedem Modell können beliebig viele Tags zugeordnet werden. 
**Ein Tag sollte genutzt werden, um Quellsysteme & Vewerndungszwecke identifizieren zu können.** Werden neue Tags eingeführt, so sind diese in der folgenden Auflistung zu ergänzen:
- **backenddaten:** Enthält Daten aus Backendsystemen (bspw. Admintool)
- **bing ads:** Modell enthält Daten aus Bing Ads (Quellsystem)
- **google ads:** Modell enthält Daten aus Google Ads (Quellsystem)
- **google analytics:** Modell enthält Daten aus Google Analytics (Quellsystem)
- **linkedin:** Modell enthält Daten aus LinkedIn (Quellsystem)
- **meta:** Modell enthält Daten aus Meta (Quellsystem)
- **performancereporting:** Dient als Input für Performancereporting der NDG
- **vermarktungsdashboard:** Dient als Input für das Vermarktungsdashboard der NDG

# Weitere Informationen
-

{% enddocs %}