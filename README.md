# NYC Airbnb Market Expansion Strategy (SQL)

## Overview
An exploratory data analysis of the New York City Airbnb dataset to identify optimal neighborhood expansion targets. By evaluating price distributions, supply density, and review-based demand metrics, this analysis pinpoints underserved, high-yield markets across all five boroughs.

## Core Analysis & Findings
* **Data Preparation:** Cleaned text fields using string casing functions and populated null review values with baseline defaults.
* **Supply & Price Distribution:** Calculated average nightly prices and total active listings grouped by borough and individual neighborhoods.
* **High-Demand / Low-Supply Opportunities:** Filtered for neighborhoods with fewer than 10 total listings but an average review frequency exceeding 2 reviews/month to flag high-demand, low-competition markets.

## Key Business Recommendations
* Targeted high-performing, low-density neighborhoods offer the strongest immediate yield potential for host expansion without overcrowding existing saturated markets.

## Skills & Concepts Used
* Aggregations & Groupings (`GROUP BY`, `HAVING`)
* Window Functions (`AVG() OVER(PARTITION BY...)`)
* Conditional Logic (`CASE WHEN`)
* Market Basket & Demand Analysis
