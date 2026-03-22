// creating vehicles table 
create table vehicles (
    id int primary key,
    owner_name string,
    registration_number string,
    vehicle_type string,
    chassis_number string
);

// creating table for vehicle telemetry data
create table vehicle_data (
    vehicle_id int,
    time_stamp timestamp,
    speed int,
    engine_temp int,
    battery float,
    gps string
);

//creating alert table
create table alerts (
    vehicle_id int,
    time_stamp timestamp,
    alerts string,
    priority string
);
