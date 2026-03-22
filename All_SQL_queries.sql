create database main_vehicle;
create schema main_vehicle.vehicle;

use database main_vehicle;
use schema vehicle;

// creating vehicles table 
create table vehicles (
    id int primary key,
    owner_name string,
    registration_number string,
    vehicle_type string,
    chassis_number string
);

// inserting static data to the table
insert into vehicles VALUES
(1, 'Adarsh Devadiga', 'KA-19-AB-1234', 'LMV', 'CHS123456789');

 show tables;
 select * from vehicles;

 
 // creating table for vehicle telemetry data
create table vehicle_data (
    vehicle_id int,
    time_stamp timestamp,
    speed int,
    engine_temp int,
    battery float,
    gps string
);

select * from vehicle_data;


//showing the alerts after receiving data from python code
select v.owner_name, d.time_stamp,
    trim(
        concat(
                case when d.engine_temp > 90 then 'OVERHEATING ' else '' end,
                case when d.battery < 9 then 'LOW BATTERY ' else '' end,
                case when d.speed > 85 then 'HIGH SPEED ' else '' end
            )
        )as alerts,
        case 
            when d.engine_temp > 90 then 'OVERHEATING'
            when d.battery < 9 then 'LOW BATTERY'
            when d.speed > 85 then 'HIGH SPEED'
            else 'NORMAL'
        end as priority
from vehicle_data d
join vehicles v
on d.vehicle_id = v.id
order by d.time_stamp desc;

//creating alert table
create table alerts (
    vehicle_id int,
    time_stamp timestamp,
    alerts string,
    priority string
);

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

//running the alert task
alter task alert_task resume;

select * from alerts
order by time_stamp desc;

//pausing the alert task
alter task alert_task suspend;