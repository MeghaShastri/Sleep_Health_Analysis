
CREATE VIEW vw_ExecutiveKPIs AS

SELECT

    ROUND(
        AVG(
            CASE
                WHEN [Sleep_Duration] IS NOT NULL
                THEN [Sleep_Duration]
            END
        ),
        2
    ) AS Avg_Sleep_Duration,

    ROUND(
        AVG(
            CASE
                WHEN [Quality_of_Sleep] IS NOT NULL
                THEN [Quality_of_Sleep]
            END
        ),
        2
    ) AS Avg_Sleep_Quality,

    ROUND(
        AVG(
            CASE
                WHEN [Stress_Lvl] IS NOT NULL
                THEN [Stress_Lvl]
            END
        ),
        2
    ) AS Avg_Stress_Level,

    ROUND(
        SUM(
            CASE
                WHEN [Sleep_Disorder] IS NOT NULL
                     AND [Sleep_Disorder] <> 'None'
                THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        COUNT([Sleep_Disorder]),
        2
    ) AS Sleep_Disorder_Rate

FROM Sleep_health_and_lifestyle_dataset;


SELECT * FROM vw_ExecutiveKPIs;
