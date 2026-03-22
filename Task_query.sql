// alert autonomous storing function
CREATE OR REPLACE TASK alert_task
WAREHOUSE = COMPUTE_WH
SCHEDULE = '1 MINUTE'
AS

INSERT INTO alerts
SELECT 
    d.vehicle_id,
    d.time_stamp,
    coalesce(
    nullify(
    TRIM(
        CONCAT(
            CASE WHEN d.engine_temp > 90 THEN 'OVERHEATING ' ELSE '' END,
            CASE WHEN d.battery < 9 THEN 'LOW BATTERY ' ELSE '' END,
            CASE WHEN d.speed > 85 THEN 'HIGH SPEED ' ELSE '' END
        )
    ),
    ''
    ),
    'Normal'
    )AS alerts,

    CASE 
        WHEN d.engine_temp > 90 THEN 'HIGH'
        WHEN d.battery < 9 THEN 'MEDIUM'
        WHEN d.speed > 85 THEN 'LOW'
        ELSE 'NORMAL'
    END AS priority

FROM vehicle_data d
WHERE d.time_stamp > (
    SELECT COALESCE(MAX(time_stamp), '1970-01-01') FROM alerts
);