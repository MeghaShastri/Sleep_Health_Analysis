# Sleep Health & Workplace Stress Data Analysis

An end-to-end SQL analysis exploring how occupational demands, daily activity levels, and sleep patterns impact cardiovascular health risks across 374 workers.

---

**[🔗 Click Here to View the Live Interactive Dashboard on Tableau Cloud](https://prod-ch-a.online.tableau.com/t/maggipinky96-96b4bcb241/authoring/Sleep_Health_Analysis/Dashboard3#1)**

---

## 1. Executive Summary & Problem Statement

This project analyzes the Kaggle **Sleep Health and Lifestyle Dataset** (374 records) using SQL to uncover actionable wellness insights across different career roles. 

The goal is to demonstrate how data-driven segmentation can highlight occupational burnout, sleep inefficiencies, and cardiovascular risk factors that standard corporate wellness programs miss.

* **The Challenge:** Corporate burnout and chronic lifestyle strain lead to hidden productivity losses and skyrocketing healthcare costs. 
* **The Approach:** Analyzed the Sleep Health dataset by building a custom multi-variable risk model, processing it via SQL, and publishing an interactive dashboard on Tableau Cloud.
* **The Impact:** Proves that physiological risk is heavily concentrated in specific mid-career and high-demand roles, providing a roadmap for targeted corporate wellness spend.

---

## 2. Tech Stack & Tools

* **Database:** SQLite / DB Browser for SQLite
* **Query Language:** SQL (`CASE WHEN` conditional flags, `GROUP BY`, `HAVING`, aggregation functions)
* **Dataset:** 374 worker records including Sleep Duration, Quality of Sleep, Daily Steps, Physical Activity Level, Stress Level, BMI Category, and Blood Pressure.
* **Data Visualization:** Tableau Cloud
  
---

## 3. The Analytical Framework ("Triple Risk")

To move beyond basic averages, individuals were flagged under a compound vulnerability index if they met **all three** criteria simultaneously:
1. **High Blood Pressure:** Systolic $\ge$ 130 or Diastolic $\ge$ 85.
2. **High Physiological Strain:** Overweight or Obese BMI.
3. **Compromised Rest:** Quality of Sleep score $\le$ 6 out of 10.

---

## 4. Data Cleaning & SQL Highlights

The data cleaning and aggregation pipeline was built using modular SQL queries. Key technical implementations include:
* **String Parsing (`SPLIT_PART`):** Extracted and cast nested string measurements (e.g., converting `"140/90"` from the Blood Pressure column) into distinct numerical systolic and diastolic fields to accurately evaluate cardiovascular risk thresholds.
* **Demographic Categorization (`CASE` Statements):** Standardized continuous age variables into strategic categories (`Under 30`, `30-39`, `40-49`, `50+`) to uncover demographic concentration patterns.
* **Multi-Factor Conditional Aggregation:** Built a single-pass risk pipeline using conditional `COUNT(CASE WHEN ...)` logic to simultaneously evaluate multiple physiological variables.

```sql
WITH CategorizedData AS (
    SELECT 
        -- 1. Create Demographic Age Brackets
        CASE 
            WHEN Age < 30 THEN 'Under 30'
            WHEN Age BETWEEN 30 AND 39 THEN '30-39'
            WHEN Age BETWEEN 40 AND 49 THEN '40-49'
            WHEN Age >= 50 THEN '50+'
            ELSE 'Unknown'
        END AS age_group,
        
        Occupation,
        systolic_bp,
		diastolic_bp,       
        BMI_Category,
        Quality_of_Sleep,
        Sleep_Disorder
    FROM Sleep_health_and_lifestyle_dataset 
)
SELECT 
    age_group,
    Occupation,
    COUNT(*) AS total_people,
    
    -- Count meeting ALL 3 risk criteria:
    -- 1. High BP (Systolic >= 130 OR Diastolic >= 85)
    -- 2. High BMI (Overweight or Obese)
    -- 3. Poor Sleep Quality (Score <= 6 out of 10)
    COUNT(
        CASE 
            WHEN (systolic_bp >= 130 OR diastolic_bp >= 85)
                 AND LOWER(BMI_Category) IN ('overweight', 'obese')
                 AND Quality_of_Sleep <= 6
            THEN 1 
        END
    ) AS triple_risk_count,
    
    -- Percentage of people in that specific age + occupation bucket with Triple Risk
    ROUND(
        CAST(
            COUNT(
                CASE 
                    WHEN (systolic_bp >= 130 OR diastolic_bp >= 85)
                         AND LOWER(BMI_Category) IN ('overweight', 'obese')
                         AND Quality_of_Sleep <= 6
                    THEN 1 
                END
            ) * 100.0 / COUNT(*) AS NUMERIC
        ), 1
    ) AS triple_risk_pct,
    
    -- Sleep disorders count in this bucket
    COUNT(CASE WHEN LOWER(Sleep_Disorder) != 'none' THEN 1 END) AS total_sleep_disorders
FROM CategorizedData
GROUP BY 
    age_group, 
    Occupation
ORDER BY 
    age_group ASC, 
    triple_risk_pct DESC,
    Occupation ASC;

```
* *(Full scripts available in the `/sql` directory).*

---

## 5. Visual Dashboard & Key Findings

The Tableau Cloud dashboard is structured as a 4-part executive data story, guiding stakeholders from lifestyle inputs to ultimate business risk:

1. **Sleep Quality by Occupation (Sorted Bar Chart):** Highlights how demanding job roles suffer from significantly lower rest scores due to occupational stress.
2. **Sleep Disorder Prevalence (Horizontal Bar Chart):** Identifies that nearly **42%** of the workforce suffers from diagnosed chronic conditions (**20.5% Insomnia**, **20.8% Sleep Apnea**).
3. **Activity Tiers vs. Physiological Metrics (Dual-Line Chart):** Proves that higher daily movement correlates with superior cardiovascular efficiency and restorative sleep.
4. **Multi-Variable Risk Matrix (Age × Occupation Highlight/Heatmap):** This chart pinpoints high-risk age groups and occupations that need corporate wellness support first."

---

## 6. Key Takeaways and Strategic Recommendations

1. **Target Wellness Resources Where Risks Are Highest:** 
   Instead of general health programs for everyone, consider focusing wellness support (like stress-management tools) on mid-career age groups and high-stress departments.
2. **Review Shift Patterns in High-Stress Roles:** 
   Since high-step employees in demanding roles still report poor sleep, reviewing shift rotations and rest periods for front-line teams could help lower burnout.
3. **Promote Basic Health Screenings:** 
   With over 40% of people in this dataset showing sleep disorders or high blood pressure, encouraging routine health check-ups could help catch health risks early.
   
---
